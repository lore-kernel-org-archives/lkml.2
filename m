Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1BQDAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:00:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34098 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1BQC7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nvmUxUEOMzKZQkU/l2LpKEHv5rY/xBFNRMc5CQvG68wTdRbKIqoT3ceM7Cr3ZZ1dfo
         mFiWuVCxdurAruyvwuJfTdJNsQ/v8XxjBuyblk823zAgHx6wVmlFofbsiu8ya7+Is74C
         cm/XCu+5Hx/04uFGTYvJmkSIP3BD2mlxRX9c8=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 06/10] Staging: tidspbridge: fixed spaces before tabs issues
Date: Thu, 17 Feb 2011 03:58:50 +0100
Message-Id: <1297911534-31534-6-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-5-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-5-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index 1159a50..de65109 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -145,8 +145,8 @@ struct map_l4_peripheral {
 #define L4_PERIPHERAL_MBOX        0x48094000
 #define DSPVA_PERIPHERAL_MBOX     0x11808000
 
-#define PM_GRPSEL_BASE 			0x48307000
-#define DSPVA_GRPSEL_BASE 		0x11821000
+#define PM_GRPSEL_BASE		0x48307000
+#define DSPVA_GRPSEL_BASE	0x11821000
 
 #define L4_PERIPHERAL_SIDETONE_MCBSP2        0x49028000
 #define DSPVA_PERIPHERAL_SIDETONE_MCBSP2 0x11824000
diff --git a/drivers/staging/tidspbridge/core/_tiomap_pwr.h b/drivers/staging/tidspbridge/core/_tiomap_pwr.h
index bd0354d..7bbd380 100644
--- a/drivers/staging/tidspbridge/core/_tiomap_pwr.h
+++ b/drivers/staging/tidspbridge/core/_tiomap_pwr.h
@@ -40,7 +40,7 @@ extern int sleep_dsp(struct bridge_dev_context *dev_context,
 			    u32 dw_cmd, void *pargs);
 /*
  *  ========interrupt_dsp========
- *  	  Sends an interrupt to DSP unconditionally.
+ *	Sends an interrupt to DSP unconditionally.
  */
 extern void interrupt_dsp(struct bridge_dev_context *dev_context,
 							u16 mb_val);
@@ -53,24 +53,24 @@ extern int dsp_peripheral_clk_ctrl(struct bridge_dev_context
 					*dev_context, void *pargs);
 /*
  *  ======== handle_hibernation_from_dsp ========
- *  	Handle Hibernation requested from DSP
+ *	Handle Hibernation requested from DSP
  */
 int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context);
 /*
  *  ======== post_scale_dsp ========
- *  	Handle Post Scale notification to DSP
+ *	Handle Post Scale notification to DSP
  */
 int post_scale_dsp(struct bridge_dev_context *dev_context,
 							void *pargs);
 /*
  *  ======== pre_scale_dsp ========
- *  	Handle Pre Scale notification to DSP
+ *	Handle Pre Scale notification to DSP
  */
 int pre_scale_dsp(struct bridge_dev_context *dev_context,
 							void *pargs);
 /*
  *  ======== handle_constraints_set ========
- *  	Handle constraints request from DSP
+ *	Handle constraints request from DSP
  */
 int handle_constraints_set(struct bridge_dev_context *dev_context,
 				  void *pargs);
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index fb9026e..1b679f8 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -51,7 +51,7 @@
 
 /*
  *  ======== handle_constraints_set ========
- *  	Sets new DSP constraint
+ *	Sets new DSP constraint
  */
 int handle_constraints_set(struct bridge_dev_context *dev_context,
 				  void *pargs)
@@ -75,7 +75,7 @@ int handle_constraints_set(struct bridge_dev_context *dev_context,
 
 /*
  *  ======== handle_hibernation_from_dsp ========
- *  	Handle Hibernation requested from DSP
+ *	Handle Hibernation requested from DSP
  */
 int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context)
 {
@@ -144,7 +144,7 @@ int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context)
 
 /*
  *  ======== sleep_dsp ========
- *  	Put DSP in low power consuming state.
+ *	Put DSP in low power consuming state.
  */
 int sleep_dsp(struct bridge_dev_context *dev_context, u32 dw_cmd,
 		     void *pargs)
@@ -250,7 +250,7 @@ int sleep_dsp(struct bridge_dev_context *dev_context, u32 dw_cmd,
 
 /*
  *  ======== wake_dsp ========
- *  	Wake up DSP from sleep.
+ *	Wake up DSP from sleep.
  */
 int wake_dsp(struct bridge_dev_context *dev_context, void *pargs)
 {
@@ -276,7 +276,7 @@ int wake_dsp(struct bridge_dev_context *dev_context, void *pargs)
 
 /*
  *  ======== dsp_peripheral_clk_ctrl ========
- *  	Enable/Disable the DSP peripheral clocks as needed..
+ *	Enable/Disable the DSP peripheral clocks as needed..
  */
 int dsp_peripheral_clk_ctrl(struct bridge_dev_context *dev_context,
 				   void *pargs)
diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
index 2126f59..9c6047f 100644
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@ -27,7 +27,7 @@
 
 #ifdef CONFIG_TIDSPBRIDGE_WDT3
 
-#define OMAP34XX_WDT3_BASE 		(L4_PER_34XX_BASE + 0x30000)
+#define OMAP34XX_WDT3_BASE		(L4_PER_34XX_BASE + 0x30000)
 
 static struct dsp_wdt_setting dsp_wdt;
 
diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/tidspbridge/dynload/cload.c
index c85a5e8..9620a73 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -212,8 +212,8 @@ int dynamic_load_module(struct dynamic_loader_stream *module,
  * Effect:
  *      The module image is read using *module.  Target storage for the new
  *      image is
- * 	obtained from *alloc.  Symbols defined and referenced by the module are
- * 	managed using *syms.  The image is then relocated and references
+ *      obtained from *alloc.  Symbols defined and referenced by the module are
+ *      managed using *syms.  The image is then relocated and references
  *      resolved as necessary, and the resulting executable bits are placed
  *      into target memory using *init.
  *
@@ -409,8 +409,8 @@ void dload_headers(struct dload_state *dlthis)
 /*	COFF Section Processing
  *
  *	COFF sections are read in and retained intact.  Each record is embedded
- * 	in a new structure that records the updated load and
- * 	run addresses of the section */
+ *	in a new structure that records the updated load and
+ *	run addresses of the section */
 
 static const char secn_errid[] = { "section" };
 
diff --git a/drivers/staging/tidspbridge/dynload/reloc.c b/drivers/staging/tidspbridge/dynload/reloc.c
index 7b28c07..2245851 100644
--- a/drivers/staging/tidspbridge/dynload/reloc.c
+++ b/drivers/staging/tidspbridge/dynload/reloc.c
@@ -85,7 +85,7 @@ rvalue dload_unpack(struct dload_state *dlthis, tgt_au_t * data, int fieldsz,
  * Parameters:
  *	val		Value to insert
  *	data	Pointer to storage unit containing lowest host address of
- * 		image data
+ *              image data
  *	fieldsz	Size of bit field, 0 < fieldsz <= sizeof(rvalue)*BITS_PER_AU
  *	offset	Offset from LSB, 0 <= offset < BITS_PER_AU
  *	sgn	Signedness of the field (ROP_SGN, ROP_UNS, ROP_MAX, ROP_ANY)
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index 014f5d5..88fdb93 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -48,69 +48,69 @@ enum hw_mmu_page_size_t {
 };
 
 /*
- * FUNCTION	      : mmu_flush_entry
+ * FUNCTION		: mmu_flush_entry
  *
  * INPUTS:
  *
- *       Identifier      : base_address
+ *       Identifier	: base_address
  *       Type		: const u32
- *       Description     : Base Address of instance of MMU module
+ *       Description	: Base Address of instance of MMU module
  *
  * RETURNS:
  *
  *       Type		: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description	: 0		 -- No errors occured
  *			 RET_BAD_NULL_PARAM     -- A Pointer
  *						Paramater was set to NULL
  *
- * PURPOSE:	      : Flush the TLB entry pointed by the
- *			lock counter register
- *			even if this entry is set protected
+ * PURPOSE:		: Flush the TLB entry pointed by the
+ *			  lock counter register
+ *			  even if this entry is set protected
  *
- * METHOD:	       : Check the Input parameter and Flush a
- *			 single entry in the TLB.
+ * METHOD:		: Check the Input parameter and Flush a
+ *			  single entry in the TLB.
  */
 static hw_status mmu_flush_entry(const void __iomem *base_address);
 
 /*
- * FUNCTION	      : mmu_set_cam_entry
+ * FUNCTION		: mmu_set_cam_entry
  *
  * INPUTS:
  *
- *       Identifier      : base_address
+ *       Identifier	: base_address
  *       TypE		: const u32
- *       Description     : Base Address of instance of MMU module
+ *       Description	: Base Address of instance of MMU module
  *
- *       Identifier      : page_sz
+ *       Identifier	: page_sz
  *       TypE		: const u32
- *       Description     : It indicates the page size
+ *       Description	: It indicates the page size
  *
- *       Identifier      : preserved_bit
+ *       Identifier	: preserved_bit
  *       Type		: const u32
- *       Description     : It indicates the TLB entry is preserved entry
+ *       Description	: It indicates the TLB entry is preserved entry
  *							or not
  *
- *       Identifier      : valid_bit
+ *       Identifier	: valid_bit
  *       Type		: const u32
- *       Description     : It indicates the TLB entry is valid entry or not
+ *       Description	: It indicates the TLB entry is valid entry or not
  *
  *
- *       Identifier      : virtual_addr_tag
- *       Type	    	: const u32
- *       Description     : virtual Address
+ *       Identifier	: virtual_addr_tag
+ *       Type		: const u32
+ *       Description	: virtual Address
  *
  * RETURNS:
  *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *						   was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
- *						   of Range
+ *       Type		: hw_status
+ *       Description	: 0				-- No errors occured
+ *			  RET_BAD_NULL_PARAM		-- A Pointer Paramater
+ *							   was set to NULL
+ *			  RET_PARAM_OUT_OF_RANGE	-- Input Parameter out
+ *							   of Range
  *
- * PURPOSE:	      	: Set MMU_CAM reg
+ * PURPOSE:		: Set MMU_CAM reg
  *
- * METHOD:	       	: Check the Input parameters and set the CAM entry.
+ * METHOD:		: Check the Input parameters and set the CAM entry.
  */
 static hw_status mmu_set_cam_entry(const void __iomem *base_address,
 				   const u32 page_sz,
@@ -119,43 +119,43 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
 				   const u32 virtual_addr_tag);
 
 /*
- * FUNCTION	      : mmu_set_ram_entry
+ * FUNCTION		: mmu_set_ram_entry
  *
  * INPUTS:
  *
- *       Identifier      : base_address
- *       Type	    	: const u32
- *       Description     : Base Address of instance of MMU module
+ *       Identifier	: base_address
+ *       Type		: const u32
+ *       Description	: Base Address of instance of MMU module
  *
- *       Identifier      : physical_addr
- *       Type	    	: const u32
- *       Description     : Physical Address to which the corresponding
- *			 virtual   Address shouldpoint
+ *       Identifier	: physical_addr
+ *       Type		: const u32
+ *       Description	: Physical Address to which the corresponding
+ *			  virtual   Address shouldpoint
  *
- *       Identifier      : endianism
- *       Type	    	: hw_endianism_t
- *       Description     : endianism for the given page
+ *       Identifier	: endianism
+ *       Type		: hw_endianism_t
+ *       Description	: endianism for the given page
  *
- *       Identifier      : element_size
- *       Type	    	: hw_element_size_t
- *       Description     : The element size ( 8,16, 32 or 64 bit)
+ *       Identifier	: element_size
+ *       Type		: hw_element_size_t
+ *       Description	: The element size ( 8,16, 32 or 64 bit)
  *
- *       Identifier      : mixed_size
- *       Type	    	: hw_mmu_mixed_size_t
- *       Description     : Element Size to follow CPU or TLB
+ *       Identifier	: mixed_size
+ *       Type		: hw_mmu_mixed_size_t
+ *       Description	: Element Size to follow CPU or TLB
  *
  * RETURNS:
  *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *							was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
- *							out of Range
+ *       Type		: hw_status
+ *       Description	: 0				-- No errors occured
+ *			  RET_BAD_NULL_PARAM		-- A Pointer Paramater
+ *							   was set to NULL
+ *			  RET_PARAM_OUT_OF_RANGE	-- Input Parameter
+ *							   out of Range
  *
- * PURPOSE:	      : Set MMU_CAM reg
+ * PURPOSE:		: Set MMU_CAM reg
  *
- * METHOD:	       : Check the Input parameters and set the RAM entry.
+ * METHOD:		: Check the Input parameters and set the RAM entry.
  */
 static hw_status mmu_set_ram_entry(const void __iomem *base_address,
 				   const u32 physical_addr,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
index 38122db..4d99bbc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
@@ -60,7 +60,7 @@ struct cfg_hostres {
 	 *                          reserved.
 	 *      dw_chnl_buf_size:      Size of channel buffer to send to RMS
 	 *      dw_num_chnls:		Total number of channels
-	 *      			(including reserved).
+	 *				(including reserved).
 	 */
 	u32 dw_chnl_offset;
 	u32 dw_chnl_buf_size;
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index 6ad313f..8299aa1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -70,7 +70,7 @@ extern void *cmm_calloc_buf(struct cmm_object *hcmm_mgr,
  *      Create a communication memory manager object.
  *  Parameters:
  *      ph_cmm_mgr:	Location to store a communication manager handle on
- *      		output.
+ *			output.
  *      hdev_obj: Handle to a device object.
  *      mgr_attrts: Comm mem manager attributes.
  *  Returns:
@@ -152,7 +152,7 @@ extern int cmm_free_buf(struct cmm_object *hcmm_mgr,
  *  Parameters:
  *      hprocessor:   Handle to a Processor.
  *      ph_cmm_mgr:	Location to store the shared memory mgr handle on
- *      		output.
+ *			output.
  *
  *  Returns:
  *      0:        Cmm Mgr opaque handle returned.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 0ae7d16..cf30048 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -370,7 +370,7 @@ typedef void (*fxn_deh_notify) (struct deh_mgr *hdeh_mgr,
  *  Parameters:
  *      chnl:           Location to store a channel object handle.
  *      hchnl_mgr:	Handle to channel manager, as returned by
- *      		CHNL_GetMgr().
+ *			CHNL_GetMgr().
  *      chnl_mode:          One of {CHNL_MODETODSP, CHNL_MODEFROMDSP} specifies
  *                      direction of data transfer.
  *      ch_id:        If CHNL_PICKFREE is specified, the channel manager will
diff --git a/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h b/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
index 5d165cd..b152abf 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
@@ -74,7 +74,7 @@
  *   ---------------------------------
  *   |0|0|1|0|0|0|x|x|x|x|x|c|c|c|c|c|
 
- * 	0010 00xx xxxc cccc
+ *	0010 00xx xxxc cccc
  *	0010 00nn pppp qqqq
  *	nn:
  *	00 = reserved
diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 49ed5c1..7638b2a 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -570,7 +570,7 @@ extern int node_get_uuid_props(void *hprocessor,
  * @sym_addr_output:	Symbol Output address
  * @sym_name:		String with the symbol name of the closest symbol
  *
- * 	This function finds the closest symbol to the address where a MMU
+ *	This function finds the closest symbol to the address where a MMU
  *	Fault occurred on the DSP side.
  */
 int node_find_addr(struct node_mgr *node_mgr, u32 sym_addr,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/ntfy.h b/drivers/staging/tidspbridge/include/dspbridge/ntfy.h
index cbc8819..ac1a835 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/ntfy.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/ntfy.h
@@ -38,7 +38,7 @@ struct ntfy_object {
  * ntfy_event - structure store specify event to be notified
  * @noti_block:	List of notify objects
  * @event:	event that it respond
- * @type: 	event type (only DSP_SIGNALEVENT supported)
+ * @type:	event type (only DSP_SIGNALEVENT supported)
  * @sync_obj:	sync_event used to set the event
  *
  */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h b/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
index 7bc5574..2fec63b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
@@ -30,7 +30,7 @@
 /* Memory Types: */
 #define RMS_CODE                0	/* Program space */
 #define RMS_DATA                1	/* Data space */
-#define RMS_IO                	2	/* I/O space */
+#define RMS_IO                  2	/* I/O space */
 
 /* RM Server Command and Response Buffer Sizes: */
 #define RMS_COMMANDBUFSIZE     256	/* Size of command buffer */
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 878aa50..9fb5113 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -1557,7 +1557,7 @@ void find_symbol_callback(void *elem, void *user_data)
  * @sym_addr_output:	Symbol Output address
  * @name_output:		String with the dsp symbol
  *
- * 	This function retrieves the dsp symbol from the dsp binary.
+ *	This function retrieves the dsp symbol from the dsp binary.
  */
 bool dbll_find_dsp_symbol(struct dbll_library_obj *zl_lib, u32 address,
 				u32 offset_range, u32 *sym_addr_output,
diff --git a/drivers/staging/tidspbridge/rmgr/dspdrv.c b/drivers/staging/tidspbridge/rmgr/dspdrv.c
index 7a6fc73..d533a07 100644
--- a/drivers/staging/tidspbridge/rmgr/dspdrv.c
+++ b/drivers/staging/tidspbridge/rmgr/dspdrv.c
@@ -39,7 +39,7 @@
 
 /*
  *  ======== dsp_init ========
- *  	Allocates bridge resources. Loads a base image onto DSP, if specified.
+ *	Allocates bridge resources. Loads a base image onto DSP, if specified.
  */
 u32 dsp_init(u32 *init_status)
 {
@@ -111,7 +111,7 @@ func_cont:
 
 /*
  *  ======== dsp_deinit ========
- *  	Frees the resources allocated for bridge.
+ *	Frees the resources allocated for bridge.
  */
 bool dsp_deinit(u32 device_context)
 {
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 28354bb..2dc976b 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -241,7 +241,7 @@ struct nldr_nodeobject {
 	 *  Mask indicating whether each mem segment specified in seg_id[]
 	 *  is preferred or required.
 	 *  For example
-	 *  	if (code_data_flag_mask & (1 << EXECUTEDATAFLAGBIT)) != 0,
+	 *	if (code_data_flag_mask & (1 << EXECUTEDATAFLAGBIT)) != 0,
 	 *  then it is required to load execute phase data into the memory
 	 *  specified by seg_id[EXECUTEDATAFLAGBIT].
 	 */
@@ -1890,7 +1890,7 @@ static bool find_in_persistent_lib_array(struct nldr_nodeobject *nldr_node_obj,
  * @offset_output:		Symbol Output address
  * @sym_name:		String with the dsp symbol
  *
- * 	This function finds the node library for a given address and
+ *	This function finds the node library for a given address and
  *	retrieves the dsp symbol by calling dbll_find_dsp_symbol.
  */
 int nldr_find_addr(struct nldr_nodeobject *nldr_node, u32 sym_addr,
-- 
1.7.1

