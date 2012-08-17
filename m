Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2HQQHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:07:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63694 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2HQQHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:07:23 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: bcm: Fix typo in drivers/bcm
Date: Sat, 18 Aug 2012 01:07:16 +0900
Message-Id: <1345219636-15356-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in drivers/bcm

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/bcm/PHSModule.c                | 4 ++--
 drivers/staging/bcm/cntrl_SignalingInterface.h | 2 +-
 drivers/staging/bcm/nvm.c                      | 2 +-
 drivers/staging/bcm/target_params.h            | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
index 4795742..6dc0bbc 100644
--- a/drivers/staging/bcm/PHSModule.c
+++ b/drivers/staging/bcm/PHSModule.c
@@ -66,7 +66,7 @@ Input parameters:		IN struct bcm_mini_adapter *Adapter         - Miniport Adapte
 						BOOLEAN bHeaderSuppressionEnabled - indicates if header suprression is enabled for SF.
 
 Return:					STATUS_SUCCESS - If the send was successful.
-						Other          - If an error occured.
+						Other  - If an error occurred.
 */
 
 int PHSTransmit(struct bcm_mini_adapter *Adapter,
@@ -346,7 +346,7 @@ int phs_init(PPHS_DEVICE_EXTENSION pPhsdeviceExtension, struct bcm_mini_adapter
 
 
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_DISPATCH, DBG_LVL_ALL, "\n phs_init Successfull");
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_DISPATCH, DBG_LVL_ALL, "\n phs_init Successful");
 	return STATUS_SUCCESS;
 }
 
diff --git a/drivers/staging/bcm/cntrl_SignalingInterface.h b/drivers/staging/bcm/cntrl_SignalingInterface.h
index 7619e4b..41d732d 100644
--- a/drivers/staging/bcm/cntrl_SignalingInterface.h
+++ b/drivers/staging/bcm/cntrl_SignalingInterface.h
@@ -223,7 +223,7 @@ typedef struct _stServiceFlowParamSI{
 	/**  8bit Indicates whether or not MBS service is requested for this Serivce Flow*/
 	B_UINT8							u8MBSService;
 
-    /**  8bit QOS Parameter Set specifies proper application of QoS paramters to Provisioned, Admitted and Active sets*/
+    /**  8bit QOS Parameter Set specifies proper application of QoS parameters to Provisioned, Admitted and Active sets*/
     B_UINT8                         u8QosParamSet;
 
    /**  8bit Traffic Priority Of the Service Flow */
diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index b179dba..ed592e0 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -3932,7 +3932,7 @@ int validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, PFLASH2X_READWRIT
 				BcmGetSectionValStartOffset(Adapter, ISO_IMAGE2_PART3);
 		}
 
-		/* since this uiSectEndoffset is the size of iso Image. hence for calculating the vitual endoffset
+		/* since this uiSectEndoffset is the size of iso Image. hence for calculating the virtual endoffset
 		 * it should be added in startoffset. so that check done in last of this function can be valued.
 		 */
 		uiSectEndOffset = uiSectStartOffset + uiSectEndOffset;
diff --git a/drivers/staging/bcm/target_params.h b/drivers/staging/bcm/target_params.h
index 1487638..ad7ec00 100644
--- a/drivers/staging/bcm/target_params.h
+++ b/drivers/staging/bcm/target_params.h
@@ -32,7 +32,7 @@ typedef struct _TARGET_PARAMS
       B_UINT32 m_u32PowerSavingModesEnable; //bit 1: 1 Idlemode enable; bit2: 1 Sleepmode Enable
 	  /* PowerSaving Mode Options:
 	     bit 0 = 1: CPE mode - to keep pcmcia if alive;
-	     bit 1 = 1: CINR reporing in Idlemode Msg
+	     bit 1 = 1: CINR reporting in Idlemode Msg
 	     bit 2 = 1: Default PSC Enable in sleepmode*/
       B_UINT32 m_u32PowerSavingModeOptions;
 
-- 
1.7.12.rc3

