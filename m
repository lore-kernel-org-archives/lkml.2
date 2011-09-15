Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935394Ab1IOXWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:22:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab1IOXWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:22:04 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: =?UTF-8?q?=5BPATCH=2002/13=5D=20staging=3A=20wlags49=5Fh2=3A=20Reindent=20hcfdef=2Eh?=
Date: Fri, 16 Sep 2011 00:20:46 +0100
Message-Id: <1316128857-9781-3-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untabified with tab-width set to 4. Reindented with linux style.

Also remove BITN macros.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcfdef.h |  817 +++++++++++++++++------------------
 1 files changed, 390 insertions(+), 427 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcfdef.h b/drivers/staging/wlags49_h2/hcfdef.h
index cb1966d..0261c73 100644
--- a/drivers/staging/wlags49_h2/hcfdef.h
+++ b/drivers/staging/wlags49_h2/hcfdef.h
@@ -1,286 +1,249 @@
-
-//   vim:tw=110:ts=4:
 #ifndef HCFDEFC_H
 #define HCFDEFC_H 1
 
 /*************************************************************************************************
-*
-* FILE	 : HCFDEF.H
-*
-* DATE   : $Date: 2004/08/05 11:47:10 $   $Revision: 1.8 $
-* Original: 2004/05/28 14:05:35    Revision: 1.59      Tag: hcf7_t20040602_01
-* Original: 2004/05/13 15:31:45    Revision: 1.53      Tag: hcf7_t7_20040513_01
-* Original: 2004/04/15 09:24:42    Revision: 1.44      Tag: hcf7_t7_20040415_01
-* Original: 2004/04/13 14:22:45    Revision: 1.43      Tag: t7_20040413_01
-* Original: 2004/04/01 15:32:55    Revision: 1.40      Tag: t7_20040401_01
-* Original: 2004/03/10 15:39:28    Revision: 1.36      Tag: t20040310_01
-* Original: 2004/03/03 14:10:12    Revision: 1.34      Tag: t20040304_01
-* Original: 2004/03/02 09:27:12    Revision: 1.32      Tag: t20040302_03
-* Original: 2004/02/24 13:00:29    Revision: 1.29      Tag: t20040224_01
-* Original: 2004/02/18 17:13:57    Revision: 1.26      Tag: t20040219_01
-*
-* AUTHOR : Nico Valster
-*
-* SPECIFICATION: ...........
-*
-* DESC   : Definitions and Prototypes for HCF only
-*
-**************************************************************************************************
-*
-*
-* SOFTWARE LICENSE
-*
-* This software is provided subject to the following terms and conditions,
-* which you should read carefully before using the software.  Using this
-* software indicates your acceptance of these terms and conditions.  If you do
-* not agree with these terms and conditions, do not use the software.
-*
-* COPYRIGHT © 1994 - 1995	by AT&T.				All Rights Reserved
-* COPYRIGHT © 1996 - 2000 by Lucent Technologies.	All Rights Reserved
-* COPYRIGHT © 2001 - 2004	by Agere Systems Inc.	All Rights Reserved
-* All rights reserved.
-*
-* Redistribution and use in source or binary forms, with or without
-* modifications, are permitted provided that the following conditions are met:
-*
-* . Redistributions of source code must retain the above copyright notice, this
-*    list of conditions and the following Disclaimer as comments in the code as
-*    well as in the documentation and/or other materials provided with the
-*    distribution.
-*
-* . Redistributions in binary form must reproduce the above copyright notice,
-*    this list of conditions and the following Disclaimer in the documentation
-*    and/or other materials provided with the distribution.
-*
-* . Neither the name of Agere Systems Inc. nor the names of the contributors
-*    may be used to endorse or promote products derived from this software
-*    without specific prior written permission.
-*
-* Disclaimer
-*
-* THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-* INCLUDING, BUT NOT LIMITED TO, INFRINGEMENT AND THE IMPLIED WARRANTIES OF
-* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ANY
-* USE, MODIFICATION OR DISTRIBUTION OF THIS SOFTWARE IS SOLELY AT THE USERS OWN
-* RISK. IN NO EVENT SHALL AGERE SYSTEMS INC. OR CONTRIBUTORS BE LIABLE FOR ANY
-* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-* ON ANY THEORY OF LIABILITY, INCLUDING, BUT NOT LIMITED TO, CONTRACT, STRICT
-* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
-* OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
-* DAMAGE.
-*
-*
-*************************************************************************************************/
+ *
+ * FILE   : HCFDEF.H
+ *
+ * DATE   : $Date: 2004/08/05 11:47:10 $   $Revision: 1.8 $
+ * Original: 2004/05/28 14:05:35    Revision: 1.59      Tag: hcf7_t20040602_01
+ * Original: 2004/05/13 15:31:45    Revision: 1.53      Tag: hcf7_t7_20040513_01
+ * Original: 2004/04/15 09:24:42    Revision: 1.44      Tag: hcf7_t7_20040415_01
+ * Original: 2004/04/13 14:22:45    Revision: 1.43      Tag: t7_20040413_01
+ * Original: 2004/04/01 15:32:55    Revision: 1.40      Tag: t7_20040401_01
+ * Original: 2004/03/10 15:39:28    Revision: 1.36      Tag: t20040310_01
+ * Original: 2004/03/03 14:10:12    Revision: 1.34      Tag: t20040304_01
+ * Original: 2004/03/02 09:27:12    Revision: 1.32      Tag: t20040302_03
+ * Original: 2004/02/24 13:00:29    Revision: 1.29      Tag: t20040224_01
+ * Original: 2004/02/18 17:13:57    Revision: 1.26      Tag: t20040219_01
+ *
+ * AUTHOR : Nico Valster
+ *
+ * SPECIFICATION: ...........
+ *
+ * DESC   : Definitions and Prototypes for HCF only
+ *
+ **************************************************************************************************
+ *
+ *
+ * SOFTWARE LICENSE
+ *
+ * This software is provided subject to the following terms and conditions,
+ * which you should read carefully before using the software.  Using this
+ * software indicates your acceptance of these terms and conditions.  If you do
+ * not agree with these terms and conditions, do not use the software.
+ *
+ * COPYRIGHT © 1994 - 1995   by AT&T.                All Rights Reserved
+ * COPYRIGHT © 1996 - 2000 by Lucent Technologies.   All Rights Reserved
+ * COPYRIGHT © 2001 - 2004   by Agere Systems Inc.   All Rights Reserved
+ * All rights reserved.
+ *
+ * Redistribution and use in source or binary forms, with or without
+ * modifications, are permitted provided that the following conditions are met:
+ *
+ * . Redistributions of source code must retain the above copyright notice, this
+ *    list of conditions and the following Disclaimer as comments in the code as
+ *    well as in the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * . Redistributions in binary form must reproduce the above copyright notice,
+ *    this list of conditions and the following Disclaimer in the documentation
+ *    and/or other materials provided with the distribution.
+ *
+ * . Neither the name of Agere Systems Inc. nor the names of the contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ *
+ * Disclaimer
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
+ * INCLUDING, BUT NOT LIMITED TO, INFRINGEMENT AND THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ANY
+ * USE, MODIFICATION OR DISTRIBUTION OF THIS SOFTWARE IS SOLELY AT THE USERS OWN
+ * RISK. IN NO EVENT SHALL AGERE SYSTEMS INC. OR CONTRIBUTORS BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, INCLUDING, BUT NOT LIMITED TO, CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
+ * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ *
+ *
+ *************************************************************************************************/
 
 
 /************************************************************************************************/
 /*********************************  P R E F I X E S  ********************************************/
 /************************************************************************************************/
-//IFB_		Interface Block
-//HCMD_		Hermes Command
-//HFS_		Hermes (Transmit/Receive) Frame Structure
-//HREG_		Hermes Register
+//IFB_      Interface Block
+//HCMD_     Hermes Command
+//HFS_      Hermes (Transmit/Receive) Frame Structure
+//HREG_     Hermes Register
 
 /*************************************************************************************************/
 
-#if 0 //
-#define BIT0  0x0001
-#define BIT1  0x0002
-#define BIT2  0x0004
-#define BIT3  0x0008
-#define BIT4  0x0010
-#define BIT5  0x0020
-#define BIT6  0x0040
-#define BIT7  0x0080
-#define BIT8  0x0100
-#define BIT9  0x0200
-#define BIT10 0x0400
-#define BIT11 0x0800
-#define BIT12 0x1000
-#define BIT13 0x2000
-#define BIT14 0x4000
-#define BIT15 0x8000
-#define BIT16 0x00010000
-#define BIT17 0x00020000
-#define BIT18 0x00040000
-#define BIT19 0x00080000
-#define BIT20 0x00100000
-#define BIT21 0x00200000
-#define BIT22 0x00400000
-#define BIT23 0x00800000
-#define BIT24 0x01000000
-#define BIT25 0x02000000
-#define BIT26 0x04000000
-#define BIT27 0x08000000
-#define BIT28 0x10000000
-#define BIT29 0x20000000
-#define BIT30 0x40000000
-#define BIT31 0x80000000
-#endif // 0
-
 /************************************************************************************************/
 /********************************* GENERAL EQUATES **********************************************/
 /************************************************************************************************/
 
 
-#define HCF_MAGIC				0x7D37	// "}7" Handle validation
+#define HCF_MAGIC               0x7D37  // "}7" Handle validation
 
-#define	PLUG_DATA_OFFSET        0x00000800	//needed by some test tool on top of H-II NDIS driver
+#define PLUG_DATA_OFFSET        0x00000800  //needed by some test tool on top of H-II NDIS driver
 
-#define INI_TICK_INI			0x00040000L
+#define INI_TICK_INI            0x00040000L
 
-#define IO_IN					0		//hcfio_in_string
-#define IO_OUT					1		//hcfio_out_string
+#define IO_IN                   0       //hcfio_in_string
+#define IO_OUT                  1       //hcfio_out_string
 
 //DO_ASSERT, create an artificial FALSE to force an ASSERT without the nasty compiler warning
-#define DO_ASSERT				( assert_ifbp->IFB_Magic != HCF_MAGIC && assert_ifbp->IFB_Magic == HCF_MAGIC )
-#define NT_ASSERT				0x0000		//, NEVER_TESTED
-#define NEVER_TESTED			MERGE_2( 0xEFFE, 0xFEEF )
-#define SE_ASSERT				0x5EFF		/* Side Effect, HCFASSERT invokation which are only called for the
-											 * side effect and which should never trigger */
-#define DHF_FILE_NAME_OFFSET	10000		//to distinguish DHF from HCF asserts by means of line number
-#define MMD_FILE_NAME_OFFSET	20000		//to distinguish MMD from HCF asserts by means of line number
+#define DO_ASSERT               ( assert_ifbp->IFB_Magic != HCF_MAGIC && assert_ifbp->IFB_Magic == HCF_MAGIC )
+#define NT_ASSERT               0x0000      //, NEVER_TESTED
+#define NEVER_TESTED            MERGE_2( 0xEFFE, 0xFEEF )
+#define SE_ASSERT               0x5EFF      /* Side Effect, HCFASSERT invokation which are only called for the
+                                             * side effect and which should never trigger */
+#define DHF_FILE_NAME_OFFSET    10000       //to distinguish DHF from HCF asserts by means of line number
+#define MMD_FILE_NAME_OFFSET    20000       //to distinguish MMD from HCF asserts by means of line number
 
 // trace codes used to
 // 1: profile execution times via HCF_TRACE and HCF_TRACE_VALUE
 // 2: hierarchical flow information via HCFLOGENTRY / HCFLOGEXIT
 
-//#define HCF_TRACE_CONNECT		useless
-//#define HCF_TRACE_DISCONNECT	useless
-#define HCF_TRACE_ACTION		0x0000  // 0x0001
-#define HCF_TRACE_CNTL			0x0001  // 0x0002
-#define HCF_TRACE_DMA_RX_GET	0x0002  // 0x0004
-#define HCF_TRACE_DMA_RX_PUT	0x0003  // 0x0008
-#define HCF_TRACE_DMA_TX_GET	0x0004  // 0x0010
-#define HCF_TRACE_DMA_TX_PUT	0x0005  // 0x0020
-#define HCF_TRACE_GET_INFO		0x0006  // 0x0040
-#define HCF_TRACE_PUT_INFO		0x0007  // 0x0080
-#define HCF_TRACE_RCV_MSG		0x0008  // 0x0100
-#define HCF_TRACE_SEND_MSG		0x0009  // 0x0200
-#define HCF_TRACE_SERVICE_NIC	0x000A  // 0x0400
+//#define HCF_TRACE_CONNECT     useless
+//#define HCF_TRACE_DISCONNECT  useless
+#define HCF_TRACE_ACTION        0x0000  // 0x0001
+#define HCF_TRACE_CNTL          0x0001  // 0x0002
+#define HCF_TRACE_DMA_RX_GET    0x0002  // 0x0004
+#define HCF_TRACE_DMA_RX_PUT    0x0003  // 0x0008
+#define HCF_TRACE_DMA_TX_GET    0x0004  // 0x0010
+#define HCF_TRACE_DMA_TX_PUT    0x0005  // 0x0020
+#define HCF_TRACE_GET_INFO      0x0006  // 0x0040
+#define HCF_TRACE_PUT_INFO      0x0007  // 0x0080
+#define HCF_TRACE_RCV_MSG       0x0008  // 0x0100
+#define HCF_TRACE_SEND_MSG      0x0009  // 0x0200
+#define HCF_TRACE_SERVICE_NIC   0x000A  // 0x0400
 // #define HCF_TRACE_           0x000C  // 0x1000
 // #define HCF_TRACE_           0x000D  // 0x2000
 // #define HCF_TRACE_           0x000E  // 0x4000
 // #define HCF_TRACE_           0x000F  // 0x8000
-//	============================================ HCF_TRACE_... codes below 0x0010 are asserted on re-entry
-#define HCF_TRACE_ACTION_KLUDGE	0x0010  /* once you start introducing kludges there is no end to it
-										 * this is an escape to do not assert on re-entrancy problem caused
-										 * by HCF_ACT_INT_FORCE_ON used to get Microsofts NDIS drivers going
-										 */
-#define HCF_TRACE_STRIO			0x0020
-#define HCF_TRACE_ALLOC			0X0021
-#define HCF_TRACE_DL			0X0023
-#define HCF_TRACE_ISR_INFO		0X0024
-#define HCF_TRACE_CALIBRATE		0x0026
-
-#define HCF_TRACE_CMD_CPL 		0x0040
-#define HCF_TRACE_CMD_EXE		0x0041
-#define HCF_TRACE_GET_FID		0x0042
-#define HCF_TRACE_GET_FRAG		0x0043
-#define HCF_TRACE_INIT			0x0044
-#define HCF_TRACE_PUT_FRAG		0x0045
-#define HCF_TRACE_SETUP_BAP		0x0046
-
-#define	HCF_TRACE_EXIT 			0x8000	// Keil C warns "long constant truncated to int"
-
-//#define BAP_0					HREG_DATA_0		//Used by DMA controller to access NIC RAM
-#define BAP_1					HREG_DATA_1		//Used by HCF to access NIC RAM
+//  ============================================ HCF_TRACE_... codes below 0x0010 are asserted on re-entry
+#define HCF_TRACE_ACTION_KLUDGE 0x0010  /* once you start introducing kludges there is no end to it
+                                         * this is an escape to do not assert on re-entrancy problem caused
+                                         * by HCF_ACT_INT_FORCE_ON used to get Microsofts NDIS drivers going
+                                         */
+#define HCF_TRACE_STRIO         0x0020
+#define HCF_TRACE_ALLOC         0X0021
+#define HCF_TRACE_DL            0X0023
+#define HCF_TRACE_ISR_INFO      0X0024
+#define HCF_TRACE_CALIBRATE     0x0026
+
+#define HCF_TRACE_CMD_CPL       0x0040
+#define HCF_TRACE_CMD_EXE       0x0041
+#define HCF_TRACE_GET_FID       0x0042
+#define HCF_TRACE_GET_FRAG      0x0043
+#define HCF_TRACE_INIT          0x0044
+#define HCF_TRACE_PUT_FRAG      0x0045
+#define HCF_TRACE_SETUP_BAP     0x0046
+
+#define HCF_TRACE_EXIT          0x8000  // Keil C warns "long constant truncated to int"
+
+//#define BAP_0                 HREG_DATA_0     //Used by DMA controller to access NIC RAM
+#define BAP_1                   HREG_DATA_1     //Used by HCF to access NIC RAM
 
 
 //************************* Hermes Receive/Transmit Frame Structures
 //HFS_STAT
 //see MMD.H for HFS_STAT_ERR
-#define 	HFS_STAT_MSG_TYPE	0xE000	//Hermes reported Message Type
-#define 	HFS_STAT_MIC_KEY_ID	0x1800	//MIC key used (if any)
-#define 	HFS_STAT_1042		0x2000	//RFC1042 Encoded
-#define 	HFS_STAT_TUNNEL		0x4000	//Bridge-Tunnel Encoded
-#define 	HFS_STAT_WMP_MSG	0x6000	//WaveLAN-II Management Protocol Frame
+#define     HFS_STAT_MSG_TYPE   0xE000  //Hermes reported Message Type
+#define     HFS_STAT_MIC_KEY_ID 0x1800  //MIC key used (if any)
+#define     HFS_STAT_1042       0x2000  //RFC1042 Encoded
+#define     HFS_STAT_TUNNEL     0x4000  //Bridge-Tunnel Encoded
+#define     HFS_STAT_WMP_MSG    0x6000  //WaveLAN-II Management Protocol Frame
 #if (HCF_TYPE) & HCF_TYPE_WPA
-#define 	HFS_STAT_MIC		0x0010	//Frame contains MIC  //;? re-instate when F/W ready
+#define     HFS_STAT_MIC        0x0010  //Frame contains MIC  //;? re-instate when F/W ready
 #endif
 
 //************************* Hermes Register Offsets and Command bits
-#define HREG_IO_RANGE			0x80		//I/O Range used by Hermes
+#define HREG_IO_RANGE           0x80        //I/O Range used by Hermes
 
 
 //************************* Command/Status
-#define HREG_CMD				0x00		//
-#define 	HCMD_CMD_CODE			0x3F
-#define HREG_PARAM_0			0x02		//
-#define HREG_PARAM_1			0x04		//
-#define HREG_PARAM_2			0x06		//
-#define HREG_STAT				0x08		//
-#define 	HREG_STAT_CMD_CODE		0x003F	//
-#define		HREG_STAT_DIAG_ERR		0x0100
-#define		HREG_STAT_INQUIRE_ERR	0x0500
-#define 	HREG_STAT_CMD_RESULT	0x7F00	//
-#define HREG_RESP_0				0x0A		//
-#define HREG_RESP_1				0x0C		//
-#define HREG_RESP_2				0x0E		//
+#define HREG_CMD                0x00        //
+#define     HCMD_CMD_CODE           0x3F
+#define HREG_PARAM_0            0x02        //
+#define HREG_PARAM_1            0x04        //
+#define HREG_PARAM_2            0x06        //
+#define HREG_STAT               0x08        //
+#define     HREG_STAT_CMD_CODE      0x003F  //
+#define     HREG_STAT_DIAG_ERR      0x0100
+#define     HREG_STAT_INQUIRE_ERR   0x0500
+#define     HREG_STAT_CMD_RESULT    0x7F00  //
+#define HREG_RESP_0             0x0A        //
+#define HREG_RESP_1             0x0C        //
+#define HREG_RESP_2             0x0E        //
 
 
 //************************* FID Management
-#define HREG_INFO_FID			0x10		//
-#define HREG_RX_FID				0x20		//
-#define HREG_ALLOC_FID  		0x22		//
-#define HREG_TX_COMPL_FID  		0x24		//
+#define HREG_INFO_FID           0x10        //
+#define HREG_RX_FID             0x20        //
+#define HREG_ALLOC_FID          0x22        //
+#define HREG_TX_COMPL_FID       0x24        //
 
 
 //************************* BAP
 //20031030 HWi Inserted this again because the dongle code uses this (GPIF.C)
-//#define HREG_SELECT_0			0x18		//
-//#define HREG_OFFSET_0			0x1C		//
-//#define HREG_DATA_0			0x36		//
+//#define HREG_SELECT_0         0x18        //
+//#define HREG_OFFSET_0         0x1C        //
+//#define HREG_DATA_0           0x36        //
 
-//#define 	HREG_OFFSET_BUSY		0x8000	// use HCMD_BUSY
-#define 	HREG_OFFSET_ERR			0x4000	//
-//rsrvd #define 	HREG_OFFSET_DATA_OFFSET	0x0FFF	//
+//#define   HREG_OFFSET_BUSY        0x8000  // use HCMD_BUSY
+#define     HREG_OFFSET_ERR         0x4000  //
+//rsrvd #define     HREG_OFFSET_DATA_OFFSET 0x0FFF  //
 
-#define HREG_SELECT_1			0x1A		//
-#define HREG_OFFSET_1			0x1E		//
-#define HREG_DATA_1				0x38		//
+#define HREG_SELECT_1           0x1A        //
+#define HREG_OFFSET_1           0x1E        //
+#define HREG_DATA_1             0x38        //
 
 
 //************************* Event
-#define HREG_EV_STAT			0x30		//
-#define HREG_INT_EN				0x32		//
-#define HREG_EV_ACK				0x34		//
+#define HREG_EV_STAT            0x30        //
+#define HREG_INT_EN             0x32        //
+#define HREG_EV_ACK             0x34        //
 
-#define    HREG_EV_TICK				0x8000	//Auxiliary Timer Tick
-//#define  HREG_EV_RES				0x4000	//H-I only: H/W error (Wait Time-out)
-#define    HREG_EV_INFO_DROP		0x2000	//WMAC did not have sufficient RAM to build Unsollicited Frame
+#define    HREG_EV_TICK             0x8000  //Auxiliary Timer Tick
+//#define  HREG_EV_RES              0x4000  //H-I only: H/W error (Wait Time-out)
+#define    HREG_EV_INFO_DROP        0x2000  //WMAC did not have sufficient RAM to build Unsollicited Frame
 #if (HCF_TYPE) & HCF_TYPE_HII5
-#define    HREG_EV_ACK_REG_READY	0x0000
+#define    HREG_EV_ACK_REG_READY    0x0000
 #else
-#define    HREG_EV_ACK_REG_READY	0x1000	//Workaround Kludge bit for H-II (not H-II.5)
+#define    HREG_EV_ACK_REG_READY    0x1000  //Workaround Kludge bit for H-II (not H-II.5)
 #endif // HCF_TYPE_HII5
 #if (HCF_SLEEP) & ( HCF_CDS | HCF_DDS )
-#define    HREG_EV_SLEEP_REQ		0x0800
+#define    HREG_EV_SLEEP_REQ        0x0800
 #else
-#define    HREG_EV_SLEEP_REQ		0x0000
+#define    HREG_EV_SLEEP_REQ        0x0000
 #endif // HCF_CDS / HCF_DDS
 #if HCF_DMA
-//#define    HREG_EV_LPESC			0x0400 // firmware sets this bit and clears it, not for host usage.
-#define    HREG_EV_RDMAD			0x0200 // rx frame in host memory
-#define    HREG_EV_TDMAD			0x0100 // tx frame in host memory processed
-//#define    HREG_EV_RXDMA			0x0040 // firmware kicks off DMA engine (bit is not for host usage)
-//#define    HREG_EV_TXDMA			0x0020 // firmware kicks off DMA engine (bit is not for host usage)
-#define    HREG_EV_FW_DMA			0x0460 // firmware / DMA engine I/F (bits are not for host usage)
+//#define    HREG_EV_LPESC          0x0400 // firmware sets this bit and clears it, not for host usage.
+#define    HREG_EV_RDMAD            0x0200 // rx frame in host memory
+#define    HREG_EV_TDMAD            0x0100 // tx frame in host memory processed
+//#define    HREG_EV_RXDMA          0x0040 // firmware kicks off DMA engine (bit is not for host usage)
+//#define    HREG_EV_TXDMA          0x0020 // firmware kicks off DMA engine (bit is not for host usage)
+#define    HREG_EV_FW_DMA           0x0460 // firmware / DMA engine I/F (bits are not for host usage)
 #else
-#define    HREG_EV_FW_DMA			0x0000
+#define    HREG_EV_FW_DMA           0x0000
 #endif // HCF_DMA
-#define    HREG_EV_INFO				0x0080	// Asynchronous Information Frame
-#define    HREG_EV_CMD				0x0010	// Command completed, Status and Response available
-#define    HREG_EV_ALLOC			0x0008	// Asynchronous part of Allocation/Reclaim completed
-#define    HREG_EV_TX_EXC			0x0004	// Asynchronous Transmission unsuccessful completed
-#define    HREG_EV_TX				0x0002	// Asynchronous Transmission successful completed
-#define    HREG_EV_RX				0x0001	// Asynchronous Receive Frame
-
-#define    HREG_EV_TX_EXT 			( (HCF_EXT) & (HCF_EXT_INT_TX_EX | HCF_EXT_INT_TICK ) )
-									/* HREG_EV_TX_EXT := 0x0000 or HREG_EV_TX_EXC and/or HREG_EV_TICK
-									 * could be extended with HREG_EV_TX */
+#define    HREG_EV_INFO             0x0080  // Asynchronous Information Frame
+#define    HREG_EV_CMD              0x0010  // Command completed, Status and Response available
+#define    HREG_EV_ALLOC            0x0008  // Asynchronous part of Allocation/Reclaim completed
+#define    HREG_EV_TX_EXC           0x0004  // Asynchronous Transmission unsuccessful completed
+#define    HREG_EV_TX               0x0002  // Asynchronous Transmission successful completed
+#define    HREG_EV_RX               0x0001  // Asynchronous Receive Frame
+
+#define    HREG_EV_TX_EXT           ( (HCF_EXT) & (HCF_EXT_INT_TX_EX | HCF_EXT_INT_TICK ) )
+/* HREG_EV_TX_EXT := 0x0000 or HREG_EV_TX_EXC and/or HREG_EV_TICK
+ * could be extended with HREG_EV_TX */
 #if HCF_EXT_INT_TX_EX != HREG_EV_TX_EXC
 err: these values should match;
 #endif // HCF_EXT_INT_TX_EX / HREG_EV_TX_EXC
@@ -290,97 +253,97 @@ err: these values should match;
 #endif // HCF_EXT_INT_TICK / HREG_EV_TICK
 
 //************************* Host Software
-#define HREG_SW_0				0x28		//
-#define HREG_SW_1				0x2A		//
-#define HREG_SW_2				0x2C		//
-//rsrvd #define HREG_SW_3		0x2E		//
+#define HREG_SW_0               0x28        //
+#define HREG_SW_1               0x2A        //
+#define HREG_SW_2               0x2C        //
+//rsrvd #define HREG_SW_3       0x2E        //
 //************************* Control and Auxiliary Port
 
-#define HREG_IO					0x12
-#define		HREG_IO_SRESET			0x0001
-#define		HREG_IO_WAKEUP_ASYNC	0x0002
-#define		HREG_IO_WOKEN_UP		0x0004
-#define HREG_CNTL				0x14		//
-//#define		HREG_CNTL_WAKEUP_SYNC	0x0001
-#define		HREG_CNTL_AUX_ENA_STAT	0xC000
-#define		HREG_CNTL_AUX_DIS_STAT	0x0000
-#define		HREG_CNTL_AUX_ENA_CNTL	0x8000
-#define		HREG_CNTL_AUX_DIS_CNTL	0x4000
-#define		HREG_CNTL_AUX_DSD		0x2000
-#define		HREG_CNTL_AUX_ENA		(HREG_CNTL_AUX_ENA_CNTL | HREG_CNTL_AUX_DIS_CNTL )
-#define HREG_SPARE				0x16		//
-#define HREG_AUX_PAGE			0x3A		//
-#define HREG_AUX_OFFSET			0x3C		//
-#define HREG_AUX_DATA			0x3E		//
+#define HREG_IO                 0x12
+#define     HREG_IO_SRESET          0x0001
+#define     HREG_IO_WAKEUP_ASYNC    0x0002
+#define     HREG_IO_WOKEN_UP        0x0004
+#define HREG_CNTL               0x14        //
+//#define       HREG_CNTL_WAKEUP_SYNC   0x0001
+#define     HREG_CNTL_AUX_ENA_STAT  0xC000
+#define     HREG_CNTL_AUX_DIS_STAT  0x0000
+#define     HREG_CNTL_AUX_ENA_CNTL  0x8000
+#define     HREG_CNTL_AUX_DIS_CNTL  0x4000
+#define     HREG_CNTL_AUX_DSD       0x2000
+#define     HREG_CNTL_AUX_ENA       (HREG_CNTL_AUX_ENA_CNTL | HREG_CNTL_AUX_DIS_CNTL )
+#define HREG_SPARE              0x16        //
+#define HREG_AUX_PAGE           0x3A        //
+#define HREG_AUX_OFFSET         0x3C        //
+#define HREG_AUX_DATA           0x3E        //
 
 #if HCF_DMA
 //************************* DMA (bus mastering)
-	// Be careful to use these registers only at a genuine 32 bits NIC
-	// On 16 bits NICs, these addresses are mapped into the range 0x00 through 0x3F with all consequences
-	// thereof, e.g.  HREG_DMA_CTRL register maps to HREG_CMD.
-#define HREG_DMA_CTRL						0x0040
-#define HREG_TXDMA_PTR32					0x0044
-#define HREG_TXDMA_PRIO_PTR32				0x0048
-#define HREG_TXDMA_HIPRIO_PTR32				0x004C
-#define HREG_RXDMA_PTR32					0x0050
-#define HREG_CARDDETECT_1					0x007C // contains 7D37
-#define HREG_CARDDETECT_2					0x007E // contains 7DE7
-#define HREG_FREETIMER						0x0058
-#define HREG_DMA_RX_CNT						0x0026
+// Be careful to use these registers only at a genuine 32 bits NIC
+// On 16 bits NICs, these addresses are mapped into the range 0x00 through 0x3F with all consequences
+// thereof, e.g.  HREG_DMA_CTRL register maps to HREG_CMD.
+#define HREG_DMA_CTRL                       0x0040
+#define HREG_TXDMA_PTR32                    0x0044
+#define HREG_TXDMA_PRIO_PTR32               0x0048
+#define HREG_TXDMA_HIPRIO_PTR32             0x004C
+#define HREG_RXDMA_PTR32                    0x0050
+#define HREG_CARDDETECT_1                   0x007C // contains 7D37
+#define HREG_CARDDETECT_2                   0x007E // contains 7DE7
+#define HREG_FREETIMER                      0x0058
+#define HREG_DMA_RX_CNT                     0x0026
 
 /******************************************************************************
-* Defines for the bits in the DmaControl register (@40h)
-******************************************************************************/
-#define HREG_DMA_CTRL_RXHWEN				0x80000000 // high word enable bit
-#define HREG_DMA_CTRL_RXRESET				0x40000000 // tx dma init bit
-#define HREG_DMA_CTRL_RXBAP1				BIT29
-#define HREG_DMA_CTRL_RX_STALLED			BIT28
-#define HREG_DMA_CTRL_RXAUTOACK_DMADONE		BIT27 // no host involvement req. for TDMADONE event
-#define HREG_DMA_CTRL_RXAUTOACK_INFO		BIT26 // no host involvement req. for alloc event
-#define HREG_DMA_CTRL_RXAUTOACK_DMAEN		0x02000000 // no host involvement req. for TxDMAen event
-#define HREG_DMA_CTRL_RXAUTOACK_RX			0x01000000 // no host involvement req. for tx event
-#define HREG_DMA_CTRL_RX_BUSY				BIT23 // read only bit
-//#define HREG_DMA_CTRL_RX_RBUFCONT_PLAIN		0	  // bits 21..20
-//#define HREG_DMA_CTRL_RX_MODE_PLAIN_DMA		0	  // mode 0
-#define HREG_DMA_CTRL_RX_MODE_SINGLE_PACKET	0x00010000 // mode 1
-#define HREG_DMA_CTRL_RX_MODE_MULTI_PACKET	0x00020000 // mode 2
-//#define HREG_DMA_CTRL_RX_MODE_DISABLE		(0x00020000|0x00010000) // disable tx dma engine
-#define HREG_DMA_CTRL_TXHWEN				0x8000 // low word enable bit
-#define HREG_DMA_CTRL_TXRESET				0x4000 // rx dma init bit
-#define HREG_DMA_CTRL_TXBAP1				BIT13
-#define HREG_DMA_CTRL_TXAUTOACK_DMADONE		BIT11 // no host involvement req. for RxDMADONE event
-#define HREG_DMA_CTRL_TXAUTOACK_DMAEN		0x00000400 // no host involvement req. for RxDMAen event
-#define HREG_DMA_CTRL_TXAUTOACK_DMAALLOC	0x00000200  // no host involvement req. for info event
-#define HREG_DMA_CTRL_TXAUTOACK_TX			0x00000100  // no host involvement req. for rx event
-#define HREG_DMA_CTRL_TX_BUSY				BIT7  // read only bit
-//#define HREG_DMA_CTRL_TX_TBUFCONT_PLAIN		0	  // bits 6..5
-//#define HREG_DMA_CTRL_TX_MODE_PLAIN_DMA		0	  // mode 0
-#define HREG_DMA_CTRL_TX_MODE_SINGLE_PACKET	BIT0 // mode 1
-#define HREG_DMA_CTRL_TX_MODE_MULTI_PACKET	0x00000002 // mode 2
-//#define HREG_DMA_CTRL_TX_MODE_DISABLE		(0x00000001|0x00000002) // disable tx dma engine
+ * Defines for the bits in the DmaControl register (@40h)
+ ******************************************************************************/
+#define HREG_DMA_CTRL_RXHWEN                0x80000000 // high word enable bit
+#define HREG_DMA_CTRL_RXRESET               0x40000000 // tx dma init bit
+#define HREG_DMA_CTRL_RXBAP1                BIT29
+#define HREG_DMA_CTRL_RX_STALLED            BIT28
+#define HREG_DMA_CTRL_RXAUTOACK_DMADONE     BIT27 // no host involvement req. for TDMADONE event
+#define HREG_DMA_CTRL_RXAUTOACK_INFO        BIT26 // no host involvement req. for alloc event
+#define HREG_DMA_CTRL_RXAUTOACK_DMAEN       0x02000000 // no host involvement req. for TxDMAen event
+#define HREG_DMA_CTRL_RXAUTOACK_RX          0x01000000 // no host involvement req. for tx event
+#define HREG_DMA_CTRL_RX_BUSY               BIT23 // read only bit
+//#define HREG_DMA_CTRL_RX_RBUFCONT_PLAIN       0     // bits 21..20
+//#define HREG_DMA_CTRL_RX_MODE_PLAIN_DMA       0     // mode 0
+#define HREG_DMA_CTRL_RX_MODE_SINGLE_PACKET 0x00010000 // mode 1
+#define HREG_DMA_CTRL_RX_MODE_MULTI_PACKET  0x00020000 // mode 2
+//#define HREG_DMA_CTRL_RX_MODE_DISABLE     (0x00020000|0x00010000) // disable tx dma engine
+#define HREG_DMA_CTRL_TXHWEN                0x8000 // low word enable bit
+#define HREG_DMA_CTRL_TXRESET               0x4000 // rx dma init bit
+#define HREG_DMA_CTRL_TXBAP1                BIT13
+#define HREG_DMA_CTRL_TXAUTOACK_DMADONE     BIT11 // no host involvement req. for RxDMADONE event
+#define HREG_DMA_CTRL_TXAUTOACK_DMAEN       0x00000400 // no host involvement req. for RxDMAen event
+#define HREG_DMA_CTRL_TXAUTOACK_DMAALLOC    0x00000200  // no host involvement req. for info event
+#define HREG_DMA_CTRL_TXAUTOACK_TX          0x00000100  // no host involvement req. for rx event
+#define HREG_DMA_CTRL_TX_BUSY               BIT7  // read only bit
+//#define HREG_DMA_CTRL_TX_TBUFCONT_PLAIN       0     // bits 6..5
+//#define HREG_DMA_CTRL_TX_MODE_PLAIN_DMA       0     // mode 0
+#define HREG_DMA_CTRL_TX_MODE_SINGLE_PACKET BIT0 // mode 1
+#define HREG_DMA_CTRL_TX_MODE_MULTI_PACKET  0x00000002 // mode 2
+//#define HREG_DMA_CTRL_TX_MODE_DISABLE     (0x00000001|0x00000002) // disable tx dma engine
 
 //configuration DWORD to configure DMA for mode2 operation, using BAP0 as the DMA BAP.
 #define DMA_CTRLSTAT_GO (HREG_DMA_CTRL_RXHWEN | HREG_DMA_CTRL_RX_MODE_MULTI_PACKET | \
                          HREG_DMA_CTRL_RXAUTOACK_DMAEN | HREG_DMA_CTRL_RXAUTOACK_RX | \
                          HREG_DMA_CTRL_TXHWEN | /*;?HREG_DMA_CTRL_TX_TBUFCONT_PLAIN |*/ \
-                         HREG_DMA_CTRL_TX_MODE_MULTI_PACKET | HREG_DMA_CTRL_TXAUTOACK_DMAEN |\
+                         HREG_DMA_CTRL_TX_MODE_MULTI_PACKET | HREG_DMA_CTRL_TXAUTOACK_DMAEN | \
                          HREG_DMA_CTRL_TXAUTOACK_DMAALLOC)
 
 //configuration DWORD to reset both the Tx and Rx DMA engines
 #define DMA_CTRLSTAT_RESET (HREG_DMA_CTRL_RXHWEN | HREG_DMA_CTRL_RXRESET | HREG_DMA_CTRL_TXHWEN | HREG_DMA_CTRL_TXRESET)
 
-//#define DESC_DMA_OWNED     		0x80000000 					// BIT31
-#define DESC_DMA_OWNED     		0x8000	 					// BIT31
-#define DESC_SOP   			 	0x8000 						// BIT15
-#define DESC_EOP   			 	0x4000 						// BIT14
+//#define DESC_DMA_OWNED            0x80000000                  // BIT31
+#define DESC_DMA_OWNED          0x8000                      // BIT31
+#define DESC_SOP                0x8000                      // BIT15
+#define DESC_EOP                0x4000                      // BIT14
 
-#define DMA_RX				0
-#define DMA_TX				1
+#define DMA_RX              0
+#define DMA_TX              1
 
-// #define IFB_RxFirstDesc		IFB_FirstDesc[DMA_RX]
-// #define IFB_TxFirstDesc		IFB_FirstDesc[DMA_TX]
-// #define IFB_RxLastDesc		IFB_LastDesc[DMA_RX]
-// #define IFB_TxLastDesc		IFB_LastDesc[DMA_TX]
+// #define IFB_RxFirstDesc      IFB_FirstDesc[DMA_RX]
+// #define IFB_TxFirstDesc      IFB_FirstDesc[DMA_TX]
+// #define IFB_RxLastDesc       IFB_LastDesc[DMA_RX]
+// #define IFB_TxLastDesc       IFB_LastDesc[DMA_TX]
 
 #endif // HCF_DMA
 //
@@ -390,96 +353,96 @@ err: these values should match;
 
 
 // Hermes Command Codes and Qualifier bits
-#define 	HCMD_BUSY			0x8000	// Busy bit, applicable for all commands
-#define HCMD_INI				0x0000	//
-#define HCMD_ENABLE				HCF_CNTL_ENABLE		// 0x0001
-#define HCMD_DISABLE			HCF_CNTL_DISABLE	// 0x0002
-#define HCMD_CONNECT			HCF_CNTL_CONNECT	// 0x0003
-#define HCMD_EXECUTE			0x0004	//
-#define HCMD_DISCONNECT			HCF_CNTL_DISCONNECT	// 0x0005
-#define HCMD_SLEEP				0x0006	//
-#define HCMD_CONTINUE			HCF_CNTL_CONTINUE	// 0x0007
-#define 	HCMD_RETRY			0x0100	// Retry bit
-#define HCMD_ALLOC				0x000A	//
-#define HCMD_TX					0x000B	//
-#define 	HCMD_RECL			0x0100	// Reclaim bit, applicable for Tx and Inquire
-#define HCMD_INQUIRE			0x0011	//
-#define HCMD_ACCESS				0x0021	//
-#define 	HCMD_ACCESS_WRITE	0x0100	// Write bit
-#define HCMD_PROGRAM			0x0022	//
-#define HCMD_READ_MIF			0x0030
-#define HCMD_WRITE_MIF			0x0031
-#define HCMD_THESEUS			0x0038
-#define 	HCMD_STARTPREAMBLE  0x0E00	// Start continuous preamble Tx
-#define 	HCMD_STOP			0x0F00	// Stop Theseus test mode
+#define     HCMD_BUSY           0x8000  // Busy bit, applicable for all commands
+#define HCMD_INI                0x0000  //
+#define HCMD_ENABLE             HCF_CNTL_ENABLE     // 0x0001
+#define HCMD_DISABLE            HCF_CNTL_DISABLE    // 0x0002
+#define HCMD_CONNECT            HCF_CNTL_CONNECT    // 0x0003
+#define HCMD_EXECUTE            0x0004  //
+#define HCMD_DISCONNECT         HCF_CNTL_DISCONNECT // 0x0005
+#define HCMD_SLEEP              0x0006  //
+#define HCMD_CONTINUE           HCF_CNTL_CONTINUE   // 0x0007
+#define     HCMD_RETRY          0x0100  // Retry bit
+#define HCMD_ALLOC              0x000A  //
+#define HCMD_TX                 0x000B  //
+#define     HCMD_RECL           0x0100  // Reclaim bit, applicable for Tx and Inquire
+#define HCMD_INQUIRE            0x0011  //
+#define HCMD_ACCESS             0x0021  //
+#define     HCMD_ACCESS_WRITE   0x0100  // Write bit
+#define HCMD_PROGRAM            0x0022  //
+#define HCMD_READ_MIF           0x0030
+#define HCMD_WRITE_MIF          0x0031
+#define HCMD_THESEUS            0x0038
+#define     HCMD_STARTPREAMBLE  0x0E00  // Start continuous preamble Tx
+#define     HCMD_STOP           0x0F00  // Stop Theseus test mode
 
 
 //Configuration Management
 //
 
-#define CFG_DRV_ACT_RANGES_PRI_3_BOTTOM	1	// Default Bottom Compatibility for Primary Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_PRI_3_TOP	1	// Default Top    Compatibility for Primary Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_PRI_3_BOTTOM 1   // Default Bottom Compatibility for Primary Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_PRI_3_TOP    1   // Default Top    Compatibility for Primary Firmware - driver I/F
 
-#define CFG_DRV_ACT_RANGES_HSI_4_BOTTOM	1	// Default Bottom Compatibility for H/W - driver I/F
-#define CFG_DRV_ACT_RANGES_HSI_4_TOP	1	// Default Top    Compatibility for H/W - driver I/F
+#define CFG_DRV_ACT_RANGES_HSI_4_BOTTOM 1   // Default Bottom Compatibility for H/W - driver I/F
+#define CFG_DRV_ACT_RANGES_HSI_4_TOP    1   // Default Top    Compatibility for H/W - driver I/F
 
-#define CFG_DRV_ACT_RANGES_HSI_5_BOTTOM	1	// Default Bottom Compatibility for H/W - driver I/F
-#define CFG_DRV_ACT_RANGES_HSI_5_TOP	1	// Default Top    Compatibility for H/W - driver I/F
+#define CFG_DRV_ACT_RANGES_HSI_5_BOTTOM 1   // Default Bottom Compatibility for H/W - driver I/F
+#define CFG_DRV_ACT_RANGES_HSI_5_TOP    1   // Default Top    Compatibility for H/W - driver I/F
 
 #if (HCF_TYPE) & HCF_TYPE_WPA
-#define CFG_DRV_ACT_RANGES_APF_1_BOTTOM	16	// Default Bottom Compatibility for AP Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_APF_1_TOP    16	// Default Top    Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_1_BOTTOM 16  // Default Bottom Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_1_TOP    16  // Default Top    Compatibility for AP Firmware - driver I/F
 #else  //;? is this REALLY O.K.
-#define CFG_DRV_ACT_RANGES_APF_1_BOTTOM	1	// Default Bottom Compatibility for AP Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_APF_1_TOP    1	// Default Top    Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_1_BOTTOM 1   // Default Bottom Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_1_TOP    1   // Default Top    Compatibility for AP Firmware - driver I/F
 #endif // HCF_TYPE_WPA
 
-#define CFG_DRV_ACT_RANGES_APF_2_BOTTOM	2	// Default Bottom Compatibility for AP Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_APF_2_TOP    2	// Default Top    Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_2_BOTTOM 2   // Default Bottom Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_2_TOP    2   // Default Top    Compatibility for AP Firmware - driver I/F
 
-#define CFG_DRV_ACT_RANGES_APF_3_BOTTOM	1	// Default Bottom Compatibility for AP Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_APF_3_TOP    1	// Default Top    Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_3_BOTTOM 1   // Default Bottom Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_3_TOP    1   // Default Top    Compatibility for AP Firmware - driver I/F
 
-#define CFG_DRV_ACT_RANGES_APF_4_BOTTOM	1	// Default Bottom Compatibility for AP Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_APF_4_TOP    1	// Default Top    Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_4_BOTTOM 1   // Default Bottom Compatibility for AP Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_APF_4_TOP    1   // Default Top    Compatibility for AP Firmware - driver I/F
 
 #if (HCF_TYPE) & HCF_TYPE_HII5
-#define CFG_DRV_ACT_RANGES_STA_2_BOTTOM	6	// Default Bottom Compatibility for Station Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_STA_2_TOP    6	// Default Top    Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_2_BOTTOM 6   // Default Bottom Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_2_TOP    6   // Default Top    Compatibility for Station Firmware - driver I/F
 #else // (HCF_TYPE) & HCF_TYPE_HII5
-#define CFG_DRV_ACT_RANGES_STA_2_BOTTOM	1	// Default Bottom Compatibility for Station Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_STA_2_TOP    2	// Default Top    Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_2_BOTTOM 1   // Default Bottom Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_2_TOP    2   // Default Top    Compatibility for Station Firmware - driver I/F
 #endif // (HCF_TYPE) & HCF_TYPE_HII5
 
-#define CFG_DRV_ACT_RANGES_STA_3_BOTTOM	1	// Default Bottom Compatibility for Station Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_STA_3_TOP    1	// Default Top    Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_3_BOTTOM 1   // Default Bottom Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_3_TOP    1   // Default Top    Compatibility for Station Firmware - driver I/F
 
-#define CFG_DRV_ACT_RANGES_STA_4_BOTTOM	1	// Default Bottom Compatibility for Station Firmware - driver I/F
-#define CFG_DRV_ACT_RANGES_STA_4_TOP    1	// Default Top    Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_4_BOTTOM 1   // Default Bottom Compatibility for Station Firmware - driver I/F
+#define CFG_DRV_ACT_RANGES_STA_4_TOP    1   // Default Top    Compatibility for Station Firmware - driver I/F
 
 //---------------------------------------------------------------------------------------------------------------------
 #if defined HCF_CFG_PRI_1_TOP || defined HCF_CFG_PRI_1_BOTTOM
-err: PRI_1 not supported for H-I;	// Compatibility for Primary Firmware - driver I/F
+err: PRI_1 not supported for H-I;   // Compatibility for Primary Firmware - driver I/F
 #endif // HCF_CFG_PRI_1_TOP / HCF_CFG_PRI_1_BOTTOM
 
 #if defined HCF_CFG_PRI_2_TOP || defined HCF_CFG_PRI_2_BOTTOM
-err: PRI_2 not supported for H-I;	// Compatibility for Primary Firmware - driver I/F
+err: PRI_2 not supported for H-I;   // Compatibility for Primary Firmware - driver I/F
 #endif // HCF_CFG_PRI_2_TOP / HCF_CFG_PRI_2_BOTTOM
 
-#ifdef HCF_CFG_PRI_3_TOP									// Top Compatibility for Primary Firmware - driver I/F
-#if HCF_CFG_PRI_3_TOP == 0 || \
+#ifdef HCF_CFG_PRI_3_TOP                                    // Top Compatibility for Primary Firmware - driver I/F
+#if HCF_CFG_PRI_3_TOP == 0 ||						\
 	CFG_DRV_ACT_RANGES_PRI_3_BOTTOM <= HCF_CFG_PRI_3_TOP && HCF_CFG_PRI_3_TOP <= CFG_DRV_ACT_RANGES_PRI_3_TOP
 #undef CFG_DRV_ACT_RANGES_PRI_3_TOP
-#define CFG_DRV_ACT_RANGES_PRI_3_TOP	HCF_CFG_PRI_3_TOP
+#define CFG_DRV_ACT_RANGES_PRI_3_TOP    HCF_CFG_PRI_3_TOP
 #else
 err: ;
 #endif
 #endif // HCF_CFG_PRI_3_TOP
 
-#ifdef HCF_CFG_PRI_3_BOTTOM                       			// Bottom Compatibility for Primary Firmware - driver I/F
+#ifdef HCF_CFG_PRI_3_BOTTOM                                 // Bottom Compatibility for Primary Firmware - driver I/F
 #if CFG_DRV_ACT_RANGES_PRI_3_BOTTOM <= HCF_CFG_PRI_3_BOTTOM && HCF_CFG_PRI_3_BOTTOM <= CFG_DRV_ACT_RANGES_PRI_3_TOP
 #undef CFG_DRV_ACT_RANGES_PRI_3_BOTTOM
-#define CFG_DRV_ACT_RANGES_PRI_3_BOTTOM	HCF_CFG_PRI_3_BOTTOM
+#define CFG_DRV_ACT_RANGES_PRI_3_BOTTOM HCF_CFG_PRI_3_BOTTOM
 #else
 err: ;
 #endif
@@ -488,77 +451,77 @@ err: ;
 
 //---------------------------------------------------------------------------------------------------------------------
 #if defined HCF_CFG_HSI_0_TOP || defined HCF_CFG_HSI_0_BOTTOM
-err: HSI_0 not supported for H-I;	// Compatibility for HSI I/F
+err: HSI_0 not supported for H-I;   // Compatibility for HSI I/F
 #endif // HCF_CFG_HSI_0_TOP / HCF_CFG_HSI_0_BOTTOM
 
 #if defined HCF_CFG_HSI_1_TOP || defined HCF_CFG_HSI_1_BOTTOM
-err: HSI_1 not supported for H-I;	// Compatibility for HSI I/F
+err: HSI_1 not supported for H-I;   // Compatibility for HSI I/F
 #endif // HCF_CFG_HSI_1_TOP / HCF_CFG_HSI_1_BOTTOM
 
 #if defined HCF_CFG_HSI_2_TOP || defined HCF_CFG_HSI_2_BOTTOM
-err: HSI_2 not supported for H-I;	// Compatibility for HSI I/F
+err: HSI_2 not supported for H-I;   // Compatibility for HSI I/F
 #endif // HCF_CFG_HSI_2_TOP / HCF_CFG_HSI_2_BOTTOM
 
 #if defined HCF_CFG_HSI_3_TOP || defined HCF_CFG_HSI_3_BOTTOM
-err: HSI_3 not supported for H-I;	// Compatibility for HSI I/F
+err: HSI_3 not supported for H-I;   // Compatibility for HSI I/F
 #endif // HCF_CFG_HSI_3_TOP / HCF_CFG_HSI_3_BOTTOM
 
-#ifdef HCF_CFG_HSI_4_TOP 									// Top Compatibility for HSI I/F
-#if HCF_CFG_HSI_4_TOP == 0 || \
+#ifdef HCF_CFG_HSI_4_TOP                                    // Top Compatibility for HSI I/F
+#if HCF_CFG_HSI_4_TOP == 0 ||						\
 	CFG_DRV_ACT_RANGES_HSI_4_BOTTOM <= CF_CFG_HSI_4_TOP && HCF_CFG_HSI_4_TOP <= CFG_DRV_ACT_RANGES_HSI_4_TOP
 #undef CFG_DRV_ACT_RANGES_HSI_4_TOP
-#define CFG_DRV_ACT_RANGES_HSI_4_TOP	HCF_CFG_HSI_4_TOP
+#define CFG_DRV_ACT_RANGES_HSI_4_TOP    HCF_CFG_HSI_4_TOP
 #else
 err: ;
 #endif
 #endif // HCF_CFG_HSI_4_TOP
 
-#ifdef HCF_CFG_HSI_4_BOTTOM								// Bottom Compatibility for HSI I/F
+#ifdef HCF_CFG_HSI_4_BOTTOM                             // Bottom Compatibility for HSI I/F
 #if CFG_DRV_ACT_RANGES_HSI_4_BOTTOM <= HCF_CFG_HSI_4_BOTTOM && HCF_CFG_HSI_4_BOTTOM <= CFG_DRV_ACT_RANGES_HSI_4_TOP
 #undef CFG_DRV_ACT_RANGES_HSI_4_BOTTOM
-#define CFG_DRV_ACT_RANGES_HSI_4_BOTTOM	HCF_CFG_HSI_4_BOTTOM
+#define CFG_DRV_ACT_RANGES_HSI_4_BOTTOM HCF_CFG_HSI_4_BOTTOM
 #else
 err: ;
 #endif
 #endif // HCF_CFG_HSI_4_BOTTOM
 
-#ifdef HCF_CFG_HSI_5_TOP 									// Top Compatibility for HSI I/F
-#if HCF_CFG_HSI_5_TOP == 0 || \
+#ifdef HCF_CFG_HSI_5_TOP                                    // Top Compatibility for HSI I/F
+#if HCF_CFG_HSI_5_TOP == 0 ||						\
 	CFG_DRV_ACT_RANGES_HSI_5_BOTTOM <= CF_CFG_HSI_5_TOP && HCF_CFG_HSI_5_TOP <= CFG_DRV_ACT_RANGES_HSI_5_TOP
 #undef CFG_DRV_ACT_RANGES_HSI_5_TOP
-#define CFG_DRV_ACT_RANGES_HSI_5_TOP	HCF_CFG_HSI_5_TOP
+#define CFG_DRV_ACT_RANGES_HSI_5_TOP    HCF_CFG_HSI_5_TOP
 #else
 err: ;
 #endif
 #endif // HCF_CFG_HSI_5_TOP
 
-#ifdef HCF_CFG_HSI_5_BOTTOM								// Bottom Compatibility for HSI I/F
+#ifdef HCF_CFG_HSI_5_BOTTOM                             // Bottom Compatibility for HSI I/F
 #if CFG_DRV_ACT_RANGES_HSI_5_BOTTOM <= HCF_CFG_HSI_5_BOTTOM && HCF_CFG_HSI_5_BOTTOM <= CFG_DRV_ACT_RANGES_HSI_5_TOP
 #undef CFG_DRV_ACT_RANGES_HSI_5_BOTTOM
-#define CFG_DRV_ACT_RANGES_HSI_5_BOTTOM	HCF_CFG_HSI_5_BOTTOM
+#define CFG_DRV_ACT_RANGES_HSI_5_BOTTOM HCF_CFG_HSI_5_BOTTOM
 #else
 err: ;
 #endif
 #endif // HCF_CFG_HSI_5_BOTTOM
 //---------------------------------------------------------------------------------------------------------------------
 #if defined HCF_CFG_APF_1_TOP || defined HCF_CFG_APF_1_BOTTOM
-err: APF_1 not supported for H-I;	// Compatibility for AP Firmware - driver I/F
+err: APF_1 not supported for H-I;   // Compatibility for AP Firmware - driver I/F
 #endif // HCF_CFG_APF_1_TOP / HCF_CFG_APF_1_BOTTOM
 
-#ifdef HCF_CFG_APF_2_TOP                  					// Top Compatibility for AP Firmware - driver I/F
-#if HCF_CFG_APF_2_TOP == 0 || \
+#ifdef HCF_CFG_APF_2_TOP                                    // Top Compatibility for AP Firmware - driver I/F
+#if HCF_CFG_APF_2_TOP == 0 ||						\
 	CFG_DRV_ACT_RANGES_APF_2_BOTTOM <= HCF_CFG_APF_2_TOP && HCF_CFG_APF_2_TOP <= CFG_DRV_ACT_RANGES_APF_2_TOP
 #undef CFG_DRV_ACT_RANGES_APF_2_TOP
-#define CFG_DRV_ACT_RANGES_APF_2_TOP	HCF_CFG_APF_2_TOP
+#define CFG_DRV_ACT_RANGES_APF_2_TOP    HCF_CFG_APF_2_TOP
 #else
 err: ;
 #endif
 #endif // HCF_CFG_APF_TOP
 
-#ifdef HCF_CFG_APF_2_BOTTOM                       			// Bottom Compatibility for AP Firmware - driver I/F
+#ifdef HCF_CFG_APF_2_BOTTOM                                 // Bottom Compatibility for AP Firmware - driver I/F
 #if CFG_DRV_ACT_RANGES_APF_2_BOTTOM <= HCF_CFG_APF_2_BOTTOM && HCF_CFG_APF_2_BOTTOM <= CFG_DRV_ACT_RANGES_APF_2_TOP
 #undef CFG_DRV_ACT_RANGES_APF_2_BOTTOM
-#define CFG_DRV_ACT_RANGES_APF_2_BOTTOM	HCF_CFG_APF_2_BOTTOM
+#define CFG_DRV_ACT_RANGES_APF_2_BOTTOM HCF_CFG_APF_2_BOTTOM
 #else
 err: ;
 #endif
@@ -566,23 +529,23 @@ err: ;
 
 //---------------------------------------------------------------------------------------------------------------------
 #if defined HCF_CFG_STA_1_TOP || defined HCF_CFG_STA_1_BOTTOM
-err: STA_1 not supported for H-I;	// Compatibility for Station Firmware - driver I/F
+err: STA_1 not supported for H-I;   // Compatibility for Station Firmware - driver I/F
 #endif // HCF_CFG_STA_1_TOP / HCF_CFG_STA_1_BOTTOM
 
-#ifdef HCF_CFG_STA_2_TOP                  					// Top Compatibility for Station Firmware - driver I/F
-#if HCF_CFG_STA_2_TOP == 0 || \
+#ifdef HCF_CFG_STA_2_TOP                                    // Top Compatibility for Station Firmware - driver I/F
+#if HCF_CFG_STA_2_TOP == 0 ||						\
 	CFG_DRV_ACT_RANGES_STA_2_BOTTOM <= HCF_CFG_STA_2_TOP && HCF_CFG_STA_2_TOP <= CFG_DRV_ACT_RANGES_STA_2_TOP
 #undef CFG_DRV_ACT_RANGES_STA_2_TOP
-#define CFG_DRV_ACT_RANGES_STA_2_TOP	HCF_CFG_STA_2_TOP
+#define CFG_DRV_ACT_RANGES_STA_2_TOP    HCF_CFG_STA_2_TOP
 #else
 err: ;
 #endif
 #endif // HCF_CFG_STA_TOP
 
-#ifdef HCF_CFG_STA_2_BOTTOM                       			// Bottom Compatibility for Station Firmware - driver I/F
+#ifdef HCF_CFG_STA_2_BOTTOM                                 // Bottom Compatibility for Station Firmware - driver I/F
 #if CFG_DRV_ACT_RANGES_STA_2_BOTTOM <= HCF_CFG_STA_2_BOTTOM && HCF_CFG_STA_2_BOTTOM <= CFG_DRV_ACT_RANGES_STA_2_TOP
 #undef CFG_DRV_ACT_RANGES_STA_2_BOTTOM
-#define CFG_DRV_ACT_RANGES_STA_2_BOTTOM	HCF_CFG_STA_2_BOTTOM
+#define CFG_DRV_ACT_RANGES_STA_2_BOTTOM HCF_CFG_STA_2_BOTTOM
 #else
 err: ;
 #endif
@@ -597,32 +560,32 @@ err: ;
 #if defined MSF_WAIT
 err: MSF should no longer supply this macro;
 #else
-#define MSF_WAIT(x) 																			\
-	{ PROT_CNT_INI														\
-		HCF_WAIT_WHILE( ( IPW( HREG_IO ) & HREG_IO_WOKEN_UP ) == 0 );						\
-		HCFASSERT( prot_cnt, IPW( HREG_IO ) )							\
-	}
+#define MSF_WAIT(x)							\
+	{ PROT_CNT_INI							\
+			HCF_WAIT_WHILE( ( IPW( HREG_IO ) & HREG_IO_WOKEN_UP ) == 0 ); \
+		HCFASSERT( prot_cnt, IPW( HREG_IO ) )			\
+			}
 #endif // MSF_WAIT
 #else
-#define MSF_WAIT(x)	/*NOP*/
+#define MSF_WAIT(x) /*NOP*/
 #endif // HCF_SLEEP
 
-#define LOF(x) 			(sizeof(x)/sizeof(hcf_16)-1)
+#define LOF(x)          (sizeof(x)/sizeof(hcf_16)-1)
 
-#define MUL_BY_2( x )	( (x) << 1 )						//used to multiply by 2
-#define DIV_BY_2( x )	( (x) >> 1 )						//used to divide by 2
+#define MUL_BY_2( x )   ( (x) << 1 )                        //used to multiply by 2
+#define DIV_BY_2( x )   ( (x) >> 1 )                        //used to divide by 2
 
 //resolve problems on for some 16 bits compilers to create 32 bit values
-#define MERGE_2( hw, lw )	( ( ((hcf_32)(hw)) << 16 ) | ((hcf_16)(lw)) )
+#define MERGE_2( hw, lw )   ( ( ((hcf_32)(hw)) << 16 ) | ((hcf_16)(lw)) )
 
 #if ! defined HCF_STATIC
-#define		  HCF_STATIC	static
-#endif //	  HCF_STATIC
+#define       HCF_STATIC    static
+#endif //     HCF_STATIC
 
 #if ( (HCF_TYPE) & HCF_TYPE_HII5 ) == 0
-#define DAWA_ACK( mask) {													\
-	OPW( HREG_EV_ACK, mask | HREG_EV_ACK_REG_READY );						\
-	OPW( HREG_EV_ACK, (mask & ~HREG_EV_ALLOC) | HREG_EV_ACK_REG_READY ); 	}
+#define DAWA_ACK( mask) {						\
+		OPW( HREG_EV_ACK, mask | HREG_EV_ACK_REG_READY );	\
+		OPW( HREG_EV_ACK, (mask & ~HREG_EV_ALLOC) | HREG_EV_ACK_REG_READY );    }
 #define DAWA_ZERO_FID(reg) OPW( reg, 0 );
 #else
 #define DAWA_ACK( mask)   OPW( HREG_EV_ACK, mask );
@@ -630,20 +593,20 @@ err: MSF should no longer supply this macro;
 #endif // HCF_TYPE_HII5
 
 #if (HCF_TYPE) & HCF_TYPE_WPA
-#define	CALC_RX_MIC( p, len ) calc_mic_rx_frag( ifbp, p, len )
-#define	CALC_TX_MIC( p, len ) calc_mic_tx_frag( ifbp, p, len )
+#define CALC_RX_MIC( p, len ) calc_mic_rx_frag( ifbp, p, len )
+#define CALC_TX_MIC( p, len ) calc_mic_tx_frag( ifbp, p, len )
 #define IF_SSN(x)  x
 #define IF_NOT_SSN(x)
 #else
-#define	CALC_RX_MIC( p, len )
-#define	CALC_TX_MIC( p, len )
+#define CALC_RX_MIC( p, len )
+#define CALC_TX_MIC( p, len )
 #define MIC_RX_RTN( mic, dw )
 #define MIC_TX_RTN( mic, dw )
 #define IF_SSN(x)
 #define IF_NOT_SSN(x) x
 #endif // HCF_TYPE_WPA
 
-#if HCF_TALLIES & HCF_TALLIES_HCF		//HCF tally support
+#if HCF_TALLIES & HCF_TALLIES_HCF       //HCF tally support
 #define IF_TALLY(x)  x
 #else
 #define IF_TALLY(x)
@@ -651,23 +614,23 @@ err: MSF should no longer supply this macro;
 
 
 #if HCF_DMA
-#define IF_DMA(x)			x
+#define IF_DMA(x)           x
 #define IF_NOT_DMA(x)
-#define IF_USE_DMA(x) 		if (   ifbp->IFB_CntlOpt & USE_DMA  ) x
-#define IF_NOT_USE_DMA(x)	if ( !(ifbp->IFB_CntlOpt & USE_DMA) ) x
+#define IF_USE_DMA(x)       if (   ifbp->IFB_CntlOpt & USE_DMA  ) x
+#define IF_NOT_USE_DMA(x)   if ( !(ifbp->IFB_CntlOpt & USE_DMA) ) x
 #else
 #define IF_DMA(x)
-#define IF_NOT_DMA(x)		x
+#define IF_NOT_DMA(x)       x
 #define IF_USE_DMA(x)
-#define IF_NOT_USE_DMA(x) 	x
+#define IF_NOT_USE_DMA(x)   x
 #endif // HCF_DMA
 
 
 #define IPW(x) ((hcf_16)IN_PORT_WORD( ifbp->IFB_IOBase + (x) ) )
 #define OPW(x, y) OUT_PORT_WORD( ifbp->IFB_IOBase + (x), y )
-	/* make sure the implementation of HCF_WAIT_WHILE is such that there may be multiple HCF_WAIT_WHILE calls
-	 * in a row and that when one fails all subsequent fail immediately without reinitialization of prot_cnt
-	 */
+/* make sure the implementation of HCF_WAIT_WHILE is such that there may be multiple HCF_WAIT_WHILE calls
+ * in a row and that when one fails all subsequent fail immediately without reinitialization of prot_cnt
+ */
 #if HCF_PROT_TIME == 0
 #define PROT_CNT_INI
 #define IF_PROT_TIME(x)
@@ -677,8 +640,8 @@ err: MSF should no longer supply this macro;
 #define HCF_WAIT_WHILE( x ) while ( x ) /*NOP*/;
 #endif // HCF_YIELD
 #else
-#define PROT_CNT_INI 	hcf_32 prot_cnt = ifbp->IFB_TickIni;
-#define IF_PROT_TIME(x)	x
+#define PROT_CNT_INI    hcf_32 prot_cnt = ifbp->IFB_TickIni;
+#define IF_PROT_TIME(x) x
 #if defined HCF_YIELD
 #define HCF_WAIT_WHILE( x ) while ( prot_cnt && (x) && (HCF_YIELD) ) prot_cnt--;
 #else
@@ -697,7 +660,7 @@ err: you used an invalid bitmask;
 #endif // HCF_EX_INT
 
 #if 0 //get compiler going
-#if HCF_EX_INT_TICK	!= HREG_EV_TICK
+#if HCF_EX_INT_TICK != HREG_EV_TICK
 ;? out dated checking
 err: someone redefined these macros while the implemenation assumes they are equal;
 #endif
@@ -724,36 +687,36 @@ err: someone redefined these macros while the implemenation assumes they are equ
 #define HCFASSERT(x,q) {if (!(x)) {mdd_assert(        ifbp, __LINE__                   , q );}}
 #define MMDASSERT(x,q) {if (!(x)) {mdd_assert( assert_ifbp, __LINE__ + FILE_NAME_OFFSET, q );}}
 
-#define HCFLOGENTRY( where, what ) 														\
-{if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {											\
-	HCF_ENTRY( ifbp ); 																	\
-	HCFASSERT( (ifbp->IFB_AssertTrace & 1<<((where)&0xF)) == 0, ifbp->IFB_AssertTrace );		\
-	ifbp->IFB_AssertTrace |= 1<<((where)&0xF);												\
-	}																					\
-HCFTRACE(ifbp, where )																	\
-HCFTRACEVALUE(ifbp, what )																\
-}
-
-#define HCFLOGEXIT( where ) 															\
-{if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {											\
-  	HCF_EXIT( ifbp ); 																	\
-	ifbp->IFB_AssertTrace &= ~(1<<((where)&0xF));												\
-	}						 															\
-HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT )													\
-}
+#define HCFLOGENTRY( where, what )					\
+	{if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {			\
+			HCF_ENTRY( ifbp );				\
+			HCFASSERT( (ifbp->IFB_AssertTrace & 1<<((where)&0xF)) == 0, ifbp->IFB_AssertTrace ); \
+			ifbp->IFB_AssertTrace |= 1<<((where)&0xF);	\
+		}							\
+		HCFTRACE(ifbp, where )					\
+			HCFTRACEVALUE(ifbp, what )			\
+			}
+
+#define HCFLOGEXIT( where )						\
+	{if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {			\
+			HCF_EXIT( ifbp );				\
+			ifbp->IFB_AssertTrace &= ~(1<<((where)&0xF));	\
+		}							\
+		HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT )			\
+			}
 
 #else // HCF_ASSERT
 #define HCFASSERT( x, q )
 #define MMDASSERT( x, q )
-#define HCFLOGENTRY( where, what ) 	  	{HCF_ENTRY( ifbp );}
-#define HCFLOGEXIT( where ) 		  	{HCF_EXIT( ifbp );}
+#define HCFLOGENTRY( where, what )      {HCF_ENTRY( ifbp );}
+#define HCFLOGEXIT( where )             {HCF_EXIT( ifbp );}
 #endif // HCF_ASSERT
 
 #if HCF_INT_ON
 /* ;? HCFASSERT_INT
  * #if (HCF_SLEEP) & HCF_DDS
  * #define HCFASSERT_INT HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFF && ifbp->IFB_IntOffCnt != 0xFFFE, \
- * 								 ifbp->IFB_IntOffCnt )
+ *                               ifbp->IFB_IntOffCnt )
  * #else
  */
 #define HCFASSERT_INT HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFF, ifbp->IFB_IntOffCnt )
@@ -764,8 +727,8 @@ HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT )													\
 
 
 #if defined HCF_TRACE
-#define HCFTRACE(ifbp, where )	   {OPW( HREG_SW_1, where );}
-//#define HCFTRACE(ifbp, where )	   {HCFASSERT( DO_ASSERT, where );}
+#define HCFTRACE(ifbp, where )     {OPW( HREG_SW_1, where );}
+//#define HCFTRACE(ifbp, where )       {HCFASSERT( DO_ASSERT, where );}
 #define HCFTRACEVALUE(ifbp, what ) {OPW( HREG_SW_2, what  );}
 //#define HCFTRACEVALUE(ifbp, what ) {HCFASSERT( DO_ASSERT, what  );}
 #else
@@ -775,7 +738,7 @@ HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT )													\
 
 
 #if HCF_BIG_ENDIAN
-#define BE_PAR(x)				,x
+#define BE_PAR(x)               ,x
 #else
 #define BE_PAR(x)
 #endif // HCF_BIG_ENDIAN
@@ -789,13 +752,13 @@ HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT )													\
 /************************************************************************************************/
 
 #if HCF_ASSERT
-extern IFBP BASED assert_ifbp;			//to make asserts easily work under MMD and DHF
-EXTERN_C void		 mdd_assert			(IFBP ifbp, unsigned int line_number, hcf_32 q );
+extern IFBP BASED assert_ifbp;          //to make asserts easily work under MMD and DHF
+EXTERN_C void        mdd_assert         (IFBP ifbp, unsigned int line_number, hcf_32 q );
 #endif //HCF_ASSERT
 
-#if ! ( (HCF_IO) & HCF_IO_32BITS )				// defined 16 bits only
+#if ! ( (HCF_IO) & HCF_IO_32BITS )              // defined 16 bits only
 #undef OUT_PORT_STRING_32
 #undef IN_PORT_STRING_32
 #endif // HCF_IO
-#endif	//HCFDEFC_H
+#endif  //HCFDEFC_H
 
-- 
1.7.4.1

