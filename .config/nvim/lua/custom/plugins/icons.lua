return {
  'nvim-tree/nvim-web-devicons',
  opts = {
    override_by_filename = {

      ['.env.local'] = {
        icon = '', -- Key icon
        name = 'dotenv',
      },
      ['.env.development'] = {
        icon = '', -- Key icon
        name = 'dotenv',
      },
      ['.env.staging'] = {
        icon = '', -- Key icon
        name = 'dotenv',
      },
      ['.env.production'] = {
        icon = '', -- Key icon
        name = 'dotenv',
      },

      ['.env'] = {
        icon = '', -- Key icon
        color = '#ffc107', -- Yellow/amber for base .env
        cterm_color = '220',
        name = 'dotenv',
      },
    },
  },
}
