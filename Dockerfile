FROM roboxes/rhel8 as Builder

#install node
RUN yum -y install curl && \
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -&& \
yum install -y nodejs

#generate build 
WORKDIR /projects
COPY package.json package-lock.json ./
RUN npm install

COPY . ./
RUN npm run build 

FROM roboxes/rhel8 AS Runner

#install node
RUN yum -y install curl && \
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash - && \
yum install -y nodejs

#Copy build folder

WORKDIR /runable
COPY --from=Builder /projects/build /runable/build
RUN npm install -g serve
USER daemon
ENTRYPOINT [ "serve","build"]
EXPOSE 3000