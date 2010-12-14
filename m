Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab0LNUez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:34:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42740 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0LNUew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:34:52 -0500
From: Rene Sapiens <rene.sapiens@ti.com>
To: omar.ramirez@ti.com
Cc: felipe.contreras@gmail.com, x0095840@ti.com, ernesto@ti.com, nm@ti.com,
        ohad@wizery.com, ameya.palande@nokia.com, x0095078@ti.com,
        ionut.nicu@mindbit.ro, ivan.gomez@ti.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Rene Sapiens <rene.sapiens@ti.com>
Subject: [PATCH 00/12]staging:tidspbridge - Remove hungarian notation from structures
Date: Tue, 14 Dec 2010 14:33:06 -0600
Message-Id: <1292358798-25875-1-git-send-email-rene.sapiens@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches remove the hungarian notation from the structure's elements.

The words to be renamed are:

Original                Replacement:
----------------        ----------------
dw_api_reg_base          api_reg_base
dw_brd_state             brd_state
dw_chnl_buf_size         chnl_buf_size
dw_chnl_offset           chnl_offset
dw_cmd                   cmd
dw_core_pm_base          core_pm_base
dw_dsp_base              dsp_base
dw_dsp_base_va           dsp_base_va
dw_dsp_bufs              dsp_bufs
dw_dsp_buf_size          dsp_buf_size
dw_dsp_clk_m2_base       dsp_clk_m2_base
dw_dsp_ext_base_addr     dsp_ext_base_addr
dw_dsp_phys_addr_offset  dsp_phys_addr_offset
dw_dsp_start_add         dsp_start_add
dw_err_mask              err_mask
dw_gpp_base_pa           gpp_base_pa
dw_api_clk_base          api_clk_base
dw_api_reg_base          api_reg_base
dw_arg                   arg
dw_arg1                  arg1
dw_arg2                  arg2
dw_chnl_buf_size         chnl_buf_size
dw_dsp_base_addr         dsp_base_addr
dw_dmmu_base             dmmu_base
dw_index                 index
dw_int_addr              int_addr
dw_internal_size         internal_size
dw_last_output           last_output
dw_mem_base              mem_base
dw_mem_length            mem_length
dw_mem_phys              mem_phys
dw_mode                  mode
dw_num_chnls             num_chnls
dw_offset_for_monitor    offset_for_monitor
dw_output_mask           output_mask
dw_page_size             page_size
dw_pa                    pa
dw_per_base              per_base
dw_per_pm_base           per_pm_base
dw_public_rhea           public_rhea
dw_seg_base_pa           seg_base_pa
dw_seg_base_va           seg_base_va
dw_self_loop             self_loop
dw_state                 state
dw_tc_endianism          tc_endianism
dw_test_base             test_base
dw_type                  type
dw_val1                  val1
dw_val2                  val2
dw_val3                  val3
dw_va                    va
dw_virt_base             virt_base
dw_vm_base               vm_base
dw_vm_size               vm_size
pfn_allocate             allocate
pfn_brd_mem_copy         brd_mem_copy
pfn_brd_mem_map          brd_mem_map
pfn_brd_mem_un_map       brd_mem_un_map
pfn_brd_mem_write        brd_mem_write
pfn_brd_monitor          brd_monitor
pfn_brd_read             brd_read
pfn_brd_set_state        brd_set_state
pfn_brd_start            brd_start
pfn_brd_status           brd_status
pfn_brd_stop             brd_stop
pfn_brd_write            brd_write
pfn_chnl_add_io_req      chnl_add_io_req
pfn_chnl_cancel_io       chnl_cancel_io
pfn_chnl_close           chnl_close
pfn_chnl_create          chnl_create
pfn_chnl_destroy         chnl_destroy
pfn_chnl_flush_io        chnl_flush_io
pfn_chnl_get_info        chnl_get_info
pfn_chnl_get_ioc         chnl_get_ioc
pfn_chnl_get_mgr_info    chnl_get_mgr_info
pfn_chnl_idle            chnl_idle
pfn_chnl_open            chnl_open
pfn_chnl_register_notify chnl_register_notify
pfn_create		 create
pfn_delete		 delete
pfn_dev_cntrl		 dev_cntrl
pfn_dev_create           by dev_create
pfn_dev_destroy          dev_destroy
pfn_exit                 exit
pfn_get_fxn_addr         get_fxn_addr
pfn_init                 init
pfn_io_create            io_create
pfn_io_destroy           io_destroy
pfn_io_get_proc_load     io_get_proc_load
pfn_io_on_loaded         io_on_loaded
pfn_load                 load
pfn_msg_create           msg_create
pfn_msg_create_queue     msg_create_queue
pfn_msg_delete           msg_delete
pfn_msg_delete_queue     msg_delete_queue
pfn_msg_get              msg_get
pfn_msg_put              msg_put
pfn_msg_register_notify  msg_register_notify
pfn_msg_set_queue_id     msg_set_queue_id
pfn_ovly                 ovly
pfn_unload               unload
pfn_write                write
pf_phase_split           phase_split
ul_alignment             alignment
ul_bufsize               bufsize
ul_bufsize_rms           bufsize_rms
ul_chnl_buf_size         chnl_buf_size
ul_chnl_offset           chnl_offset
ul_code_mem_seg_mask     code_mem_seg_mask
ul_dais_arg              dais_arg
ul_data1                 data1
ul_data_mem_seg_mask     data_mem_seg_mask
ul_dsp_addr              dsp_addr
ul_dsp_res_addr          dsp_res_addr
ul_dsp_size              dsp_size
ul_dsp_va                dsp_va
ul_dsp_virt              dsp_virt
ul_entry                 entry
ul_external_mem_size     external_mem_size
ul_fxn_addrs             fxn_addrs
ul_gpp_pa                gpp_pa
ul_gpp_phys              gpp_phys
ul_gpp_read_pointer      gpp_read_pointer
ul_gpp_size              gpp_size
ul_gpp_va                gpp_va
ul_heap_size             heap_size
ul_internal_mem_size     internal_mem_size
ul_in_use_cnt            in_use_cnt
ul_len_max_free_block    len_max_free_block
ul_max                   max
ul_min_block_size        min_block_size
ul_min                   min
ul_mpu_addr              mpu_addr
ul_n_bytes               bytes
ul_num_alloc_blocks      num_alloc_blocks
ul_number_bytes          number_bytes
ul_num_chnls             num_chnls
ul_num_free_blocks       num_free_blocks
ul_num_gppsm_segs        num_gppsm_segs
ul_pos                   pos
ul_reserved              reserved
hbridge_context          bridge_context
hchnl_mgr                chnl_mgr
hcmm_mgr                 cmm_mgr
hdcd_mgr                 dcd_mgr
hdeh_mgr                 deh_mgr
hdev_obj                 dev_obj
hdrv_obj                 drv_obj
hmgr_obj                 mgr_obj
hmsg_mgr                 msg_mgr
hnode_mgr                node_mgr
psz_last_coff            last_coff
ul_resource              resource
ul_seg_id                seg_id
ul_size                  size
ul_sm_size               sm_size
ul_total_free_size       total_free_size
ul_total_in_use_cnt      total_in_use_cnt
ul_total_seg_size        total_seg_size
ul_trace_buffer_begin    trace_buffer_begin
ul_trace_buffer_current  trace_buffer_current
ul_trace_buffer_end      trace_buffer_end
ul_unit                  unit
ul_virt_size             virt_size
us_dsp_mau_size          dsp_mau_size
us_dsp_word_size         dsp_word_size
hprocessor               processor
udma_priority            dma_priority
udsp_data_mau_size       dsp_data_mau_size
udsp_heap_addr           dsp_heap_addr
udsp_heap_res_addr       dsp_heap_res_addr
udsp_heap_virt_addr      dsp_heap_virt_addr
udsp_mau_size            dsp_mau_size
udsp_word_size           dsp_word_size
ugpp_heap_addr           gpp_heap_addr
ugpp_heap_virt_addr      gpp_heap_virt_addr
us_data2                 data2
us_data3                 data3
uc_data4                 data4
uc_data5                 data5
uc_data6                 data6
us_load_type             load_type
usm_length               sm_length
utimeout                 timeout
uwc_deadline             wc_deadline
uwc_execution_time       wc_execution_time
uwc_period               wc_period
hnext                    next
hnode                    node
hprev                    prev
hroot                    root
hstream                  stream
pbuf                     buf
pcb_arg                  cb_arg
pdspheap_list            dspheap_list
pmsg                     msg
ps_name                  name
pstr_create_phase_fxn    str_create_phase_fxn
pstr_delete_phase_fxn    str_delete_phase_fxn
pstr_dev_name            str_dev_name
pstr_event_name          str_event_name
pstr_execute_phase_fxn   str_execute_phase_fxn
pstr_i_alg_name          str_i_alg_name
udma_chnl_id             dma_chnl_id
un_bufs_in_strm          bufs_in_strm
usm_buf_size             sm_buf_size
hio_mgr                  io_mgr
dw_api_reg_base          api_reg_base
dw_api_clk_base          api_clk_base
ap_channel               channels
pio_requests             io_requests
pio_completions          io_completions
pndb_props               ndb_props
pndb_props_size          ndb_props_size
pu_num_nodes             num_nodes
pu_num_procs             num_procs
psz_path_name            sz_path_name
pu_index                 index
pargs                    args
pu_allocated             allocated
psize                    size
hnotification            notification
pp_rsv_addr              rsv_addr
prsv_addr                rsv_addr
pmpu_addr                mpu_addr
pp_map_addr              map_addr
ul_map_attr              map_attr
undb_props_size          ndb_props_size
dw_buf_size              buf_size
dw_bytes                 bytes
pattr                    attr
pdw_arg                  arg
ph_cmm_mgr               cmm_mgr
ph_event                 event
ph_node                  node
ph_stream                stream
pmask                    mask
pp_argv                  argv
pp_buf_va                buf_va
pstatus                  status
ul_flags                 flags
ul_seg_id                seg_id
usize                    size 

Rene Sapiens (12):
  staging:tidspbridge - set1 remove hungarian from structs
  staging:tidspbridge - set2 remove hungarian from structs
  staging:tidspbridge - set3 remove hungarian from structs
  staging:tidspbridge - set4 remove hungarian from structs
  staging:tidspbridge - set5 remove hungarian from structs
  staging:tidspbridge - set6 remove hungarian from structs
  staging:tidspbridge - set7 remove hungarian from structs
  staging:tidspbridge - set8 remove hungarian from structs
  staging:tidspbridge - set9 remove hungarian from structs
  staging:tidspbridge - set10 remove hungarian from structs
  staging:tidspbridge - set11 remove hungarian from structs
  staging:tidspbridge - set12 remove hungarian from structs

 drivers/staging/tidspbridge/core/_deh.h            |    2 +-
 drivers/staging/tidspbridge/core/_msg_sm.h         |    4 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   30 +-
 drivers/staging/tidspbridge/core/chnl_sm.c         |  120 +++---
 drivers/staging/tidspbridge/core/io_sm.c           |  384 +++++++++---------
 drivers/staging/tidspbridge/core/msg_sm.c          |   22 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |  194 +++++-----
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |  108 +++---
 drivers/staging/tidspbridge/core/tiomap_io.c       |   92 +++---
 drivers/staging/tidspbridge/core/ue_deh.c          |   28 +-
 drivers/staging/tidspbridge/dynload/cload.c        |   42 +-
 .../staging/tidspbridge/dynload/dload_internal.h   |    6 +-
 drivers/staging/tidspbridge/gen/uuidutil.c         |   22 +-
 .../tidspbridge/include/dspbridge/_chnl_sm.h       |   22 +-
 .../tidspbridge/include/dspbridge/cfgdefs.h        |   34 +-
 .../tidspbridge/include/dspbridge/chnldefs.h       |    6 +-
 .../tidspbridge/include/dspbridge/chnlpriv.h       |    8 +-
 .../staging/tidspbridge/include/dspbridge/cmm.h    |    2 +-
 .../tidspbridge/include/dspbridge/cmmdefs.h        |   38 +-
 .../staging/tidspbridge/include/dspbridge/cod.h    |    2 +-
 .../tidspbridge/include/dspbridge/dbdcddef.h       |   14 +-
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |   72 ++--
 .../staging/tidspbridge/include/dspbridge/dev.h    |    6 +-
 .../tidspbridge/include/dspbridge/dispdefs.h       |    4 +-
 .../staging/tidspbridge/include/dspbridge/drv.h    |   16 +-
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |  212 +++++-----
 .../tidspbridge/include/dspbridge/dspdefs.h        |   78 ++--
 .../tidspbridge/include/dspbridge/dspioctl.h       |    8 +-
 .../staging/tidspbridge/include/dspbridge/iodefs.h |    2 +-
 .../tidspbridge/include/dspbridge/mgrpriv.h        |    4 +-
 .../tidspbridge/include/dspbridge/nldrdefs.h       |   24 +-
 .../tidspbridge/include/dspbridge/nodepriv.h       |   10 +-
 .../tidspbridge/include/dspbridge/strmdefs.h       |    4 +-
 drivers/staging/tidspbridge/pmgr/chnl.c            |    4 +-
 drivers/staging/tidspbridge/pmgr/cmm.c             |  224 ++++++------
 drivers/staging/tidspbridge/pmgr/cod.c             |    6 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |   12 +-
 drivers/staging/tidspbridge/pmgr/dev.c             |  268 +++++++-------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |  272 +++++++-------
 drivers/staging/tidspbridge/pmgr/io.c              |    8 +-
 drivers/staging/tidspbridge/pmgr/ioobj.h           |    4 +-
 drivers/staging/tidspbridge/pmgr/msg.c             |    4 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   58 ++--
 drivers/staging/tidspbridge/rmgr/disp.c            |   82 ++--
 drivers/staging/tidspbridge/rmgr/drv.c             |   86 ++--
 drivers/staging/tidspbridge/rmgr/mgr.c             |   16 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |  114 +++---
 drivers/staging/tidspbridge/rmgr/node.c            |  414 ++++++++++----------
 drivers/staging/tidspbridge/rmgr/proc.c            |  168 ++++----
 drivers/staging/tidspbridge/rmgr/pwr.c             |    8 +-
 drivers/staging/tidspbridge/rmgr/rmm.c             |   18 +-
 drivers/staging/tidspbridge/rmgr/strm.c            |   86 ++--
 52 files changed, 1736 insertions(+), 1736 deletions(-)

