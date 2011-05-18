Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1ERKnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:43:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47237 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab1ERKm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AET/af1oDaQeh+iBN8gRWpSE3poBXBEIfdU766/sKe5cVh3ylm9H+2EJ+5bE5hjW/b
         twD95nC1sWnQCb3styRhtBB/ehEa4eUN17c8P8xjhXNJBXlURMQDEz5wBb6tuv/0X5GH
         RZ5xXxhuGKnnE1lT/gUwIVl6m6HCq9VEyVkrY=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, jj@chaosbits.net, imirkin@alum.mit.edu,
        devel@driverdev.osuosl.org, jlee@novell.com, acho@novell.com
Subject: [PATCH 5/7] staging/keucr: fix keucr smil.h coding style
Date: Wed, 18 May 2011 18:40:13 +0800
Message-Id: <60b4d913775e1d28c0a2dc13c334a77bcabf330d.1305714525.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr smil.h coding style

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/smil.h |  291 ++++++++++++++++++++++--------------------
 1 files changed, 150 insertions(+), 141 deletions(-)

diff --git a/drivers/staging/keucr/smil.h b/drivers/staging/keucr/smil.h
index 2450605..b5a8fa7 100644
--- a/drivers/staging/keucr/smil.h
+++ b/drivers/staging/keucr/smil.h
@@ -44,21 +44,22 @@ Retry Counter Definition
 /***************************************************************************
 Hardware ECC Definition
 ***************************************************************************/
-#define HW_ECC_SUPPORTED    1      /* Hardware ECC Supported */  /* No difinition for Software ECC */
+#define HW_ECC_SUPPORTED    1	   /* Hardware ECC Supported */
+/* No difinition for Software ECC */
 
 /***************************************************************************
 SmartMedia Command & Status Definition
 ***************************************************************************/
 /* SmartMedia Command */
 #define WRDATA        0x80
-//#define READ          0x00
+/* #define READ          0x00 */
 #define READ_REDT     0x50
-//#define WRITE         0x10
+/* #define WRITE         0x10 */
 #define RDSTATUS      0x70
 
-#define READ1         0x00 //NO
-#define READ2         0x01 //NO
-#define READ3         0x50 //NO
+#define READ1         0x00 /* NO */
+#define READ2         0x01 /* NO */
+#define READ3         0x50 /* NO */
 #define RST_CHIP      0xFF
 #define ERASE1        0x60
 #define ERASE2        0xD0
@@ -67,19 +68,19 @@ SmartMedia Command & Status Definition
 #define READ_ID_3     0x9A
 
 /* 712 SmartMedia Command */
-#define SM_CMD_RESET                0x00    // 0xFF
-#define SM_CMD_READ_ID_1            0x10    // 0x90
-#define SM_CMD_READ_ID_2            0x20    // 0x91
-#define SM_CMD_READ_STAT            0x30    // 0x70
-#define SM_CMD_RDMULTPL_STAT        0x40    // 0x71
-#define SM_CMD_READ_1               0x50    // 0x00
-#define SM_CMD_READ_2               0x60    // 0x01
-#define SM_CMD_READ_3               0x70    // 0x50
-#define SM_CMD_PAGPRGM_TRUE         0x80    // {0x80, 0x10}
-#define SM_CMD_PAGPRGM_DUMY         0x90    // {0x80, 0x11}
-#define SM_CMD_PAGPRGM_MBLK         0xA0    // {0x80, 0x15}
-#define SM_CMD_BLKERASE             0xB0    // {0x60, 0xD0}
-#define SM_CMD_BLKERASE_MULTPL      0xC0    // {0x60-0x60, 0xD0}
+#define SM_CMD_RESET                0x00    /* 0xFF */
+#define SM_CMD_READ_ID_1            0x10    /* 0x90 */
+#define SM_CMD_READ_ID_2            0x20    /* 0x91 */
+#define SM_CMD_READ_STAT            0x30    /* 0x70 */
+#define SM_CMD_RDMULTPL_STAT        0x40    /* 0x71 */
+#define SM_CMD_READ_1               0x50    /* 0x00 */
+#define SM_CMD_READ_2               0x60    /* 0x01 */
+#define SM_CMD_READ_3               0x70    /* 0x50 */
+#define SM_CMD_PAGPRGM_TRUE         0x80    /* {0x80, 0x10} */
+#define SM_CMD_PAGPRGM_DUMY         0x90    /* {0x80, 0x11} */
+#define SM_CMD_PAGPRGM_MBLK         0xA0    /* {0x80, 0x15} */
+#define SM_CMD_BLKERASE             0xB0    /* {0x60, 0xD0} */
+#define SM_CMD_BLKERASE_MULTPL      0xC0    /* {0x60-0x60, 0xD0} */
 
 #define SM_CRADDTCT_DEBNCETIMER_EN  0x02
 #define SM_CMD_START_BIT            0x01
@@ -87,27 +88,31 @@ SmartMedia Command & Status Definition
 #define SM_WaitCmdDone { while (!SM_CmdDone); }
 #define SM_WaitDmaDone { while (!SM_DmaDone); }
 
-// SmartMedia Status
-#define WR_FAIL       0x01      // 0:Pass, 1:Fail
-#define SUSPENDED     0x20      // 0:Not Suspended, 1:Suspended
-#define READY         0x40      // 0:Busy, 1:Ready
-#define WR_PRTCT      0x80      // 0:Protect, 1:Not Protect
-
-// SmartMedia Busy Time (1bit:0.1ms)
-#define BUSY_PROG     200       // tPROG   : 20ms  ----- Program Time          old : 200
-#define BUSY_ERASE    4000      // tBERASE : 400ms ----- Block Erase Time      old : 4000
-//for 712 Test
-//#define BUSY_READ     1         // tR      : 100us ----- Data transfer Time   old : 1
-//#define BUSY_READ     10         // tR      : 100us ----- Data transfer Time   old : 1
-#define BUSY_READ     200       // tR      : 20ms   ----- Data transfer Time   old : 1
-//#define BUSY_RESET    60        // tRST    : 6ms   ----- Device Resetting Time old : 60
-#define BUSY_RESET    600        // tRST    : 60ms   ----- Device Resetting Time old : 60
-
-// Hardware Timer (1bit:0.1ms)
-#define TIME_PON      3000      // 300ms ------ Power On Wait Time
-#define TIME_CDCHK    200       // 20ms  ------ Card Check Interval Timer
-#define TIME_WPCHK    50        // 5ms   ------ WP Check Interval Timer
-#define TIME_5VCHK    10        // 1ms   ------ 5V Check Interval Timer
+/* SmartMedia Status */
+#define WR_FAIL       0x01      /* 0:Pass, 1:Fail */
+#define SUSPENDED     0x20      /* 0:Not Suspended, 1:Suspended */
+#define READY         0x40      /* 0:Busy, 1:Ready */
+#define WR_PRTCT      0x80      /* 0:Protect, 1:Not Protect */
+
+/* SmartMedia Busy Time (1bit:0.1ms) */
+#define BUSY_PROG 200 /* tPROG   : 20ms  ----- Program Time old : 200 */
+#define BUSY_ERASE 4000 /* tBERASE : 400ms ----- Block Erase Time old : 4000 */
+
+/*for 712 Test */
+/* #define BUSY_READ 1 *//* tR : 100us ----- Data transfer Time   old : 1 */
+/* #define BUSY_READ 10 *//* tR : 100us ----- Data transfer Time   old : 1 */
+
+#define BUSY_READ 200 /* tR : 20ms   ----- Data transfer Time   old : 1 */
+
+/* #define BUSY_RESET 60 *//* tRST : 6ms ----- Device Resetting Time old : 60 */
+
+#define BUSY_RESET 600 /* tRST : 60ms   ----- Device Resetting Time old : 60 */
+
+/* Hardware Timer (1bit:0.1ms) */
+#define TIME_PON      3000      /* 300ms ------ Power On Wait Time */
+#define TIME_CDCHK    200       /* 20ms  ------ Card Check Interval Timer */
+#define TIME_WPCHK    50        /* 5ms   ------ WP Check Interval Timer */
+#define TIME_5VCHK    10        /* 1ms   ------ 5V Check Interval Timer */
 
 /***************************************************************************
 Redundant Data
@@ -129,32 +134,32 @@ Redundant Data
 SmartMedia Model & Attribute
 ***************************************************************************/
 /* SmartMedia Attribute */
-#define NOWP          0x00 // 0... .... No Write Protect
-#define WP            0x80 // 1... .... Write Protected
-#define MASK          0x00 // .00. .... NAND MASK ROM Model
-#define FLASH         0x20 // .01. .... NAND Flash ROM Model
-#define AD3CYC        0x00 // ...0 .... Address 3-cycle
-#define AD4CYC        0x10 // ...1 .... Address 4-cycle
-#define BS16          0x00 // .... 00.. 16page/block
-#define BS32          0x04 // .... 01.. 32page/block
-#define PS256         0x00 // .... ..00 256byte/page
-#define PS512         0x01 // .... ..01 512byte/page
-#define MWP           0x80 // WriteProtect mask
-#define MFLASH        0x60 // Flash Rom mask
-#define MADC          0x10 // Address Cycle
-#define MBS           0x0C // BlockSize mask
-#define MPS           0x03 // PageSize mask
+#define NOWP          0x00 /* 0... .... No Write Protect */
+#define WP            0x80 /* 1... .... Write Protected */
+#define MASK          0x00 /* .00. .... NAND MASK ROM Model */
+#define FLASH         0x20 /* .01. .... NAND Flash ROM Model */
+#define AD3CYC        0x00 /* ...0 .... Address 3-cycle */
+#define AD4CYC        0x10 /* ...1 .... Address 4-cycle */
+#define BS16          0x00 /* .... 00.. 16page/block */
+#define BS32          0x04 /* .... 01.. 32page/block */
+#define PS256         0x00 /* .... ..00 256byte/page */
+#define PS512         0x01 /* .... ..01 512byte/page */
+#define MWP           0x80 /* WriteProtect mask */
+#define MFLASH        0x60 /* Flash Rom mask */
+#define MADC          0x10 /* Address Cycle */
+#define MBS           0x0C /* BlockSize mask */
+#define MPS           0x03 /* PageSize mask */
 
 /* SmartMedia Model */
-#define NOSSFDC       0x00 // NO   SmartMedia
-#define SSFDC1MB      0x01 // 1MB  SmartMedia
-#define SSFDC2MB      0x02 // 2MB  SmartMedia
-#define SSFDC4MB      0x03 // 4MB  SmartMedia
-#define SSFDC8MB      0x04 // 8MB  SmartMedia
-#define SSFDC16MB     0x05 // 16MB SmartMedia
-#define SSFDC32MB     0x06 // 32MB SmartMedia
-#define SSFDC64MB     0x07 // 64MB SmartMedia
-#define SSFDC128MB    0x08 //128MB SmartMedia
+#define NOSSFDC       0x00 /* NO   SmartMedia */
+#define SSFDC1MB      0x01 /* 1MB  SmartMedia */
+#define SSFDC2MB      0x02 /* 2MB  SmartMedia */
+#define SSFDC4MB      0x03 /* 4MB  SmartMedia */
+#define SSFDC8MB      0x04 /* 8MB  SmartMedia */
+#define SSFDC16MB     0x05 /* 16MB SmartMedia */
+#define SSFDC32MB     0x06 /* 32MB SmartMedia */
+#define SSFDC64MB     0x07 /* 64MB SmartMedia */
+#define SSFDC128MB    0x08 /*128MB SmartMedia */
 #define SSFDC256MB    0x09
 #define SSFDC512MB    0x0A
 #define SSFDC1GB      0x0B
@@ -163,8 +168,7 @@ SmartMedia Model & Attribute
 /***************************************************************************
 Struct Definition
 ***************************************************************************/
-struct SSFDCTYPE
-{
+struct SSFDCTYPE {
 	BYTE Model;
 	BYTE Attribute;
 	BYTE MaxZones;
@@ -183,8 +187,7 @@ typedef struct SSFDCTYPE_T
 	WORD MaxLogBlocks;
 } *SSFDCTYPE_T;
 
-struct ADDRESS
-{
+struct ADDRESS {
 	BYTE Zone;	/* Zone Number */
 	BYTE Sector;	/* Sector(512byte) Number on Block */
 	WORD PhyBlock;	/* Physical Block Number on Zone */
@@ -199,8 +202,7 @@ typedef struct ADDRESS_T
 	WORD LogBlock;	/* Logical Block Number of Zone */
 } *ADDRESS_T;
 
-struct CIS_AREA
-{
+struct CIS_AREA {
 	BYTE Sector;	/* Sector(512byte) Number on Block */
 	WORD PhyBlock;	/* Physical Block Number on Zone 0 */
 };
@@ -219,86 +221,93 @@ extern struct SSFDCTYPE  Ssfdc;
 extern struct ADDRESS    Media;
 extern struct CIS_AREA   CisArea;
 
-//----- SMILMain.c ---------------------------------------------------
+/*
+ * SMILMain.c
+ */
 /******************************************/
-int         Init_D_SmartMedia           (void);
-int         Pwoff_D_SmartMedia          (void);
-int         Check_D_SmartMedia          (void);
-int         Check_D_Parameter           (struct us_data *,WORD *,BYTE *,BYTE *);
-int         Media_D_ReadSector          (struct us_data *,DWORD,WORD,BYTE *);
-int         Media_D_WriteSector         (struct us_data *,DWORD,WORD,BYTE *);
-int         Media_D_CopySector          (struct us_data *,DWORD,WORD,BYTE *);
-int         Media_D_EraseBlock          (struct us_data *,DWORD,WORD);
-int         Media_D_EraseAll            (struct us_data *);
+int         Init_D_SmartMedia(void);
+int         Pwoff_D_SmartMedia(void);
+int         Check_D_SmartMedia(void);
+int         Check_D_Parameter(struct us_data *, WORD *, BYTE *, BYTE *);
+int         Media_D_ReadSector(struct us_data *, DWORD, WORD, BYTE *);
+int         Media_D_WriteSector(struct us_data *, DWORD, WORD, BYTE *);
+int         Media_D_CopySector(struct us_data *, DWORD, WORD, BYTE *);
+int         Media_D_EraseBlock(struct us_data *, DWORD, WORD);
+int         Media_D_EraseAll(struct us_data *);
 /******************************************/
-int         Media_D_OneSectWriteStart   (struct us_data *,DWORD,BYTE *);
-int         Media_D_OneSectWriteNext    (struct us_data *,BYTE *);
-int         Media_D_OneSectWriteFlush   (struct us_data *);
+int         Media_D_OneSectWriteStart(struct us_data *, DWORD, BYTE *);
+int         Media_D_OneSectWriteNext(struct us_data *, BYTE *);
+int         Media_D_OneSectWriteFlush(struct us_data *);
 
 /******************************************/
 extern int	SM_FreeMem(void);	/* ENE SM function */
-void        SM_EnableLED                (struct us_data *,BOOLEAN);
-void        Led_D_TernOn                (void);
-void        Led_D_TernOff               (void);
+void        SM_EnableLED(struct us_data *, BOOLEAN);
+void        Led_D_TernOn(void);
+void        Led_D_TernOff(void);
 
-int         Media_D_EraseAllRedtData    (DWORD Index, BOOLEAN CheckBlock);
-//DWORD       Media_D_GetMediaInfo        (struct us_data * fdoExt, PIOCTL_MEDIA_INFO_IN pParamIn, PIOCTL_MEDIA_INFO_OUT pParamOut);
+int         Media_D_EraseAllRedtData(DWORD Index, BOOLEAN CheckBlock);
+/*DWORD Media_D_GetMediaInfo(struct us_data * fdoExt,
+	PIOCTL_MEDIA_INFO_IN pParamIn, PIOCTL_MEDIA_INFO_OUT pParamOut); */
 
-//----- SMILSub.c ----------------------------------------------------
+/*
+ * SMILSub.c
+ */
 /******************************************/
-int  Check_D_DataBlank            (BYTE *);
-int  Check_D_FailBlock            (BYTE *);
-int  Check_D_DataStatus           (BYTE *);
-int  Load_D_LogBlockAddr          (BYTE *);
-void Clr_D_RedundantData          (BYTE *);
-void Set_D_LogBlockAddr           (BYTE *);
-void Set_D_FailBlock              (BYTE *);
-void Set_D_DataStaus              (BYTE *);
+int  Check_D_DataBlank(BYTE *);
+int  Check_D_FailBlock(BYTE *);
+int  Check_D_DataStatus(BYTE *);
+int  Load_D_LogBlockAddr(BYTE *);
+void Clr_D_RedundantData(BYTE *);
+void Set_D_LogBlockAddr(BYTE *);
+void Set_D_FailBlock(BYTE *);
+void Set_D_DataStaus(BYTE *);
 
 /******************************************/
-void Ssfdc_D_Reset                (struct us_data *);
-int  Ssfdc_D_ReadCisSect          (struct us_data *, BYTE *,BYTE *);
-void Ssfdc_D_WriteRedtMode        (void);
-void Ssfdc_D_ReadID               (BYTE *, BYTE);
-int  Ssfdc_D_ReadSect             (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_ReadBlock            (struct us_data *, WORD, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSect            (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_WriteBlock           (struct us_data *, WORD, BYTE *,BYTE *);
-int  Ssfdc_D_CopyBlock            (struct us_data *, WORD, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSectForCopy     (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_EraseBlock           (struct us_data *);
-int  Ssfdc_D_ReadRedtData         (struct us_data *, BYTE *);
-int  Ssfdc_D_WriteRedtData        (struct us_data *, BYTE *);
-int  Ssfdc_D_CheckStatus          (void);
-int  Set_D_SsfdcModel             (BYTE);
-void Cnt_D_Reset                  (void);
-int  Cnt_D_PowerOn                (void);
-void Cnt_D_PowerOff               (void);
-void Cnt_D_LedOn                  (void);
-void Cnt_D_LedOff                 (void);
-int  Check_D_CntPower             (void);
-int  Check_D_CardExist            (void);
-int  Check_D_CardStsChg           (void);
-int  Check_D_SsfdcWP              (void);
-int  SM_ReadBlock                 (struct us_data *, BYTE *,BYTE *);
-
-int  Ssfdc_D_ReadSect_DMA         (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_ReadSect_PIO         (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSect_DMA        (struct us_data *, BYTE *,BYTE *);
-int  Ssfdc_D_WriteSect_PIO        (struct us_data *, BYTE *,BYTE *);
+void Ssfdc_D_Reset(struct us_data *);
+int  Ssfdc_D_ReadCisSect(struct us_data *, BYTE *, BYTE *);
+void Ssfdc_D_WriteRedtMode(void);
+void Ssfdc_D_ReadID(BYTE *, BYTE);
+int  Ssfdc_D_ReadSect(struct us_data *, BYTE *, BYTE *);
+int  Ssfdc_D_ReadBlock(struct us_data *, WORD, BYTE *, BYTE *);
+int  Ssfdc_D_WriteSect(struct us_data *, BYTE *, BYTE *);
+int  Ssfdc_D_WriteBlock(struct us_data *, WORD, BYTE *, BYTE *);
+int  Ssfdc_D_CopyBlock(struct us_data *, WORD, BYTE *, BYTE *);
+int  Ssfdc_D_WriteSectForCopy(struct us_data *, BYTE *, BYTE *);
+int  Ssfdc_D_EraseBlock(struct us_data *);
+int  Ssfdc_D_ReadRedtData(struct us_data *, BYTE *);
+int  Ssfdc_D_WriteRedtData(struct us_data *, BYTE *);
+int  Ssfdc_D_CheckStatus(void);
+int  Set_D_SsfdcModel(BYTE);
+void Cnt_D_Reset(void);
+int  Cnt_D_PowerOn(void);
+void Cnt_D_PowerOff(void);
+void Cnt_D_LedOn(void);
+void Cnt_D_LedOff(void);
+int  Check_D_CntPower(void);
+int  Check_D_CardExist(void);
+int  Check_D_CardStsChg(void);
+int  Check_D_SsfdcWP(void);
+int  SM_ReadBlock(struct us_data *, BYTE *, BYTE *);
+
+int  Ssfdc_D_ReadSect_DMA(struct us_data *, BYTE *, BYTE *);
+int  Ssfdc_D_ReadSect_PIO(struct us_data *, BYTE *, BYTE *);
+int  Ssfdc_D_WriteSect_DMA(struct us_data *, BYTE *, BYTE *);
+int  Ssfdc_D_WriteSect_PIO(struct us_data *, BYTE *, BYTE *);
 
 /******************************************/
-int  Check_D_ReadError            (BYTE *);
-int  Check_D_Correct              (BYTE *,BYTE *);
-int  Check_D_CISdata              (BYTE *,BYTE *);
-void Set_D_RightECC               (BYTE *);
-
-//----- SMILECC.c ----------------------------------------------------
-void calculate_ecc                (BYTE *, BYTE *, BYTE *, BYTE *, BYTE *);
-BYTE correct_data                 (BYTE *, BYTE *, BYTE,   BYTE,   BYTE);
-int  _Correct_D_SwECC             (BYTE *,BYTE *,BYTE *);
-void _Calculate_D_SwECC           (BYTE *,BYTE *);
-
-void SM_Init        (void);
-
-#endif // already included
+int  Check_D_ReadError(BYTE *);
+int  Check_D_Correct(BYTE *, BYTE *);
+int  Check_D_CISdata(BYTE *, BYTE *);
+void Set_D_RightECC(BYTE *);
+
+/*
+ * SMILECC.c
+ */
+void calculate_ecc(BYTE *, BYTE *, BYTE *, BYTE *, BYTE *);
+BYTE correct_data(BYTE *, BYTE *, BYTE,   BYTE,   BYTE);
+int  _Correct_D_SwECC(BYTE *, BYTE *, BYTE *);
+void _Calculate_D_SwECC(BYTE *, BYTE *);
+
+void SM_Init(void);
+
+#endif /* already included */
-- 
1.7.1

