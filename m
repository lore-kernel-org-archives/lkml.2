Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab0GJC2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 22:28:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52931 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0GJCZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 22:25:18 -0400
From: Rene Sapiens <rene.sapiens@ti.com>
To: greg@kroah.com
Cc: gregkh@suse.de, omar.ramirez@ti.com, ohad@wizery.com,
       ameya.palande@nokia.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Rene Sapiens <rene.sapiens@ti.com>
Subject: [PATCH 00/15] ti dspbridge: Remove CamelCase, reagroup variables
Date: Fri,  9 Jul 2010 21:23:54 -0500
Message-Id: <1278728649-21012-1-git-send-email-rene.sapiens@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intention of this serie of patches is to rename the remaining variables 
with camel case. Words will be renamed avoiding CamelCase and Hungarian 
notation. Also the variables in the prototypes  will be renamed to make them 
match with the ones in the function definitions.

The variables to be renamed are:

================= BEGIN =================
dspAddr to dsp_address
dspAdr to dsp_adr
dspBaseVirt to dsp_base_virt
dwDeviceContext to device_context
dwDSPAddrOffset to dsp_addr_offset
dwDSPAddr to dsp_addr
dwErrInfo to error_info
dwGPPBaseBA to gpp_base_ba
dwMask to mask
dwTimeout to timeout
dwTimeOut to timeout
dwValue to value
entryNum to entry_num
execFile to exec_file
fFlush to flush_data
FlushMemType to flush_mem_type
FlushType to flush_type
hDevContext to dev_ctxt
hDevExtension to dev_extension
hdevObject to device_obj
hDispObject to disp_obj
hDrVObject to driver_obj
hDRVObject to driver_obj
hMGRHandle to mgr_handle
hNldrObject to nldr
hNode1 to node1
hNode2 to node2
hNodeRes to node_resource
hPCtxt to process_ctxt
hProc to proc
hStreamHandle to stream_handle
hStrm to stream_obj
iMode to io_mode
irqMask to irq_mask
lOffset to offset
memPtr to mem_ptr
moduleId to module_id
msgCallback to msg_callback
msgList to msg_list
nArgc to num_argc
nEntryStart to entry_start
nMemSpace to mem_space
nStatus to node_status
nStrms to strms
numLibs to num_libs
numLockedEntries to num_locked_entries
pageSize to page_sz
pArb to arb
pbAlreadyAttached to already_attached
pBaseAddr to base_addr
pbHostBuf to host_buff
pBufVa to buf_va
pChnlInfo to channel_info
pConfig to config_param
pContent to content
pContext to context
pdcdProps to dcd_prop
pDepLibUuids to dep_lib_uuids
pDevNodeString to dev_node_strg
pDispAttrs to disp_attrs
pDsp to dsp
pdwAutoStart to auto_start
pdwChnl to chnl
pdwSize to buff_size
pdwState to board_state
pdwValue to value
pdwVersion to version
pElemExisting to elem_existing
pEntry to entry
pErrInfo to err_inf
pExists to exists
pfEnablePerf to enable_perf
pGenObj to gen_obj
phChnlMgr to channel_mgr
phChnl to chnl
phCodMgr to cod_mgr
phDCDHandle to dcd_handle
phDcdMgr to dcd_mgr
phDehMgr to deh_manager
phDevContext to device_ctx
phDevNode to dev_nde
phDevObject to device_obj
phDispObject to dispatch_obj
phDmmMgr to dmm_manager
phDrvObject to drv_obj
phDRVObject to drv_obj
phIOMgr to io_man
phLoader to loader
phManager to manager
phMgrObject to mgr_obj
phMgr to mgr
phMsgMgr to msg_man
phMsgQueue to msgq
phNldrNode to nldr_nodeobj
phNldrObj to nldr_ovlyobj
phNldr to nldr
phNodeMgr to node_man
pHostBuf to host_buf
pHostConfig to host_config
phRmmMgr to rmm_mgr
phStrmMgr to strm_man
phStrm to strm_objct
phXlator to xlator
physicalAddr to physical_addr
pInfo to channel_info
pIOC to chan_ioc
pLib to lib_obj
pList to lst
pMemBuf to mem_buf
pMemStatBuf to mem_stat_buf
pMgrAttrs to mgr_attrts
pMgrInfo to mgr_info
pNodeEnv to node_env
pNodeId to node_uuid
pNodeInfo to node_info
pNumLibs to num_libs
pNumPersLibs to num_pers_libs
pObjDef to obj_def
pObjUuid to obj_uuid
poolPhysBase to pool_phys_base
poolSize to pool_size
pPctxt to pctxt
ppDevContext to dev_cntxt
ppDrvInterface to drv_intf
pPersistentDepLibs to prstnt_dep_libs
pPhyAddr to phy_addr
pPhysAddr to phys_addr
pPhysicalAddress to physical_address
ppIntfFxns to if_fxns
pProcLoadStat to proc_load_stat
pProcStat to proc_lstat
ppSym to sym_val
pRefData to ref_data
pRef to ref
preservedBit to preserved_bit
pResult to result
procID to proc_id
pSectInfo to sect_inf
pSrc to src
pstrContent to str_content
pstrDummyFile to str_dummy_file
pstrExecFile to str_exec_file
pstrFxn to str_fxn
pstrLibName to str_lib_name
pstrSect to str_sect
pstrSym to str_sym
pstrZLFileName to str_zl_file_name
pstrZLFile to str_zl_file
pszCoffPath to sz_coff_path
pszMode to sz_mode
pszName to sz_name
pszSectName to sz_sect_name
pszUuid to sz_uuid
pszZlDllName to sz_zl_dll_name
puAddr to addr
pulAddr to addr
pulBufSize to buff_size
pulBytes to nbytes
puLen to len
pulEntry to entry_pt
pulFxnAddr to fxn_addr
pulId to chan_id
pulSegId to sgmt_id
pVaBuf to va_buf
pVirtualAddress to virtual_address
pwMbVal to mbx_val
pWord to word
pXlatorAttrs to xlator_attrs
registerFxn to register_fxn
rootPersistent to root_prstnt
sectionData to section_data
sectionInfo to section_info
sectionName to section_name
sectName to sec_name
segmentId to segmnt_id
SetPageDirty to set_page_dirty
sizeInBytes to size_in_bytes
sleepCode to sleep_code
Status to status
symName to sym_name
szVar to sz_var
Trapped_Args to trapped_args
TTBPhysAddr to ttb_phys_addr
uChirps to chirps
uChnlId to ch_id
uChnlID to ch_id
uContentSize to cont_size
uDDMAChnlId to ddma_chnl_id
uEvents to events
ulAlign to align_mask
ulBrdState to brd_state
ulChnl to chnl
ulDspAddr to dsp_add
ulDspDestAddr to dsp_dest_addr
ulDspLoadAddr to dsp_load_addr
ulDspRunAddr to dsp_run_addr
ulDspSrcAddr to dsp_src_addr
ulEventMask to evnt_mask
ulMapAttrs to map_attr
ulMemType to mem_type
ulRMSFxn to rms_fxn
ulStatus to ret
ulVirtAddr to virt_addr
uNumDesc to num_desc
uNumToDSP to num_to_dsp
uPaSize to pa_size
uPhase to phase
uSegId to segm_id
uStream1 to stream1
uStream2 to stream2
uZId to zid
validBit to valid_bit
victimEntryNum to victim_entry_num
virtualAddr to virtual_addr
xType to xtype
actualValue to actual_value
EASIL1_MMUMMU_IRQSTATUSReadRegister32 to easil1_mmummu_irqstatus_read_register32
EASIL1_MMUMMU_LOCKBaseValueWrite32 to easil1_mmummu_lock_base_value_write32
easiNum to easi_num
expectedValue to expected_value
invalidValue to invalid_value
L1_base to l1_base
L2_base to l2_base
lower16Bits to lower16_bits
lower8Bits to lower8_bits
lowerMiddle8Bits to lower_middle8_bits
lowerUpper8Bits to lower_upper8_bits
maxValidValue to max_valid_value
minValidValue to min_valid_value
newValue to new_value
returnCodeIfMismatch to return_code_if_mismatch
spyCodeIfMisMatch to spy_code_if_mis_match
upper16Bits to upper16_bits
upper8Bits to upper8_bits
================= END =================


Rene Sapiens (15):
  staging:ti dspbridge: Rename words with camel case.
  staging:ti dspbridge: Rename words with camel case.
  staging:ti dspbridge: Rename words with camel case.
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: Rename words with camel case.
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: Rename words with camel case.
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: Rename words with camel case.
  staging:ti dspbridge: Rename words with camel case
  staging:ti dspbridge: make variables in prototypes match within
    functions definitions

 drivers/staging/tidspbridge/core/chnl_sm.c         |  160 +++++-----
 drivers/staging/tidspbridge/core/io_sm.c           |  119 ++++----
 drivers/staging/tidspbridge/core/msg_sm.c          |   46 ++--
 drivers/staging/tidspbridge/core/tiomap3430.c      |  256 ++++++++--------
 drivers/staging/tidspbridge/core/tiomap_io.c       |   50 ++--
 drivers/staging/tidspbridge/core/tiomap_io.h       |   22 +-
 drivers/staging/tidspbridge/dynload/getsection.c   |   24 +-
 drivers/staging/tidspbridge/dynload/reloc.c        |    4 +-
 drivers/staging/tidspbridge/gen/uuidutil.c         |   40 ++--
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |    2 +-
 drivers/staging/tidspbridge/hw/GlobalTypes.h       |   72 +++---
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |   96 +++---
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  126 ++++----
 drivers/staging/tidspbridge/hw/hw_mmu.h            |   42 ++--
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   64 ++--
 .../staging/tidspbridge/include/dspbridge/chnl.h   |   20 +-
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   56 ++--
 .../staging/tidspbridge/include/dspbridge/cod.h    |   96 +++---
 .../staging/tidspbridge/include/dspbridge/dbdcd.h  |   74 +++---
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |    4 +-
 .../tidspbridge/include/dspbridge/dbldefs.h        |    9 +-
 .../staging/tidspbridge/include/dspbridge/dbll.h   |   23 +-
 .../tidspbridge/include/dspbridge/dblldefs.h       |   48 ++--
 .../staging/tidspbridge/include/dspbridge/dev.h    |  174 ++++++------
 .../staging/tidspbridge/include/dspbridge/disp.h   |   62 ++--
 .../staging/tidspbridge/include/dspbridge/dmm.h    |    6 +-
 .../staging/tidspbridge/include/dspbridge/drv.h    |   76 +++---
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |    2 +-
 .../staging/tidspbridge/include/dspbridge/dspapi.h |  116 ++++----
 .../tidspbridge/include/dspbridge/dspchnl.h        |   22 +-
 .../tidspbridge/include/dspbridge/dspdefs.h        |  321 ++++++++++----------
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |    6 +-
 .../staging/tidspbridge/include/dspbridge/dspio.h  |    6 +-
 .../staging/tidspbridge/include/dspbridge/dspmsg.h |    8 +-
 .../tidspbridge/include/dspbridge/getsection.h     |   16 +-
 drivers/staging/tidspbridge/include/dspbridge/io.h |   18 +-
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |   88 +++---
 .../staging/tidspbridge/include/dspbridge/list.h   |   68 ++--
 .../staging/tidspbridge/include/dspbridge/mgr.h    |   20 +-
 .../staging/tidspbridge/include/dspbridge/msg.h    |   12 +-
 .../tidspbridge/include/dspbridge/msgdefs.h        |    2 +-
 .../staging/tidspbridge/include/dspbridge/nldr.h   |   10 +-
 .../tidspbridge/include/dspbridge/nldrdefs.h       |   48 ++--
 .../staging/tidspbridge/include/dspbridge/node.h   |   66 ++--
 .../tidspbridge/include/dspbridge/nodepriv.h       |   14 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |   40 ++--
 .../staging/tidspbridge/include/dspbridge/pwr.h    |    6 +-
 .../include/dspbridge/resourcecleanup.h            |   43 ++--
 .../staging/tidspbridge/include/dspbridge/rmm.h    |   18 +-
 .../staging/tidspbridge/include/dspbridge/strm.h   |  108 ++++----
 .../tidspbridge/include/dspbridge/uuidutil.h       |   16 +-
 drivers/staging/tidspbridge/pmgr/chnl.c            |   22 +-
 drivers/staging/tidspbridge/pmgr/cmm.c             |   88 +++---
 drivers/staging/tidspbridge/pmgr/cod.c             |  171 ++++++-----
 drivers/staging/tidspbridge/pmgr/dbll.c            |   93 +++---
 drivers/staging/tidspbridge/pmgr/dev.c             |  156 +++++-----
 drivers/staging/tidspbridge/pmgr/dmm.c             |   20 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |  116 ++++----
 drivers/staging/tidspbridge/pmgr/io.c              |   18 +-
 drivers/staging/tidspbridge/pmgr/msg.c             |   14 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |  236 ++++++++-------
 drivers/staging/tidspbridge/rmgr/disp.c            |   52 ++--
 drivers/staging/tidspbridge/rmgr/drv.c             |  164 +++++-----
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |   10 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.h   |    7 +-
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    6 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |   22 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |  187 ++++++------
 drivers/staging/tidspbridge/rmgr/node.c            |  318 ++++++++++----------
 drivers/staging/tidspbridge/rmgr/proc.c            |   66 ++--
 drivers/staging/tidspbridge/rmgr/pwr.c             |    6 +-
 drivers/staging/tidspbridge/rmgr/rmm.c             |   39 ++--
 drivers/staging/tidspbridge/rmgr/strm.c            |  200 +++++++------
 drivers/staging/tidspbridge/services/cfg.c         |   54 ++--
 74 files changed, 2471 insertions(+), 2439 deletions(-)


