module.exports = function (grunt) {
  grunt.initConfig({
    connect: {
      server: {
        options: {
          keepalive: true,
          port: 9007,
          base: './'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-connect');
};
