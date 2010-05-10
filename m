Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0EJQsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:48:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40437 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0EJQse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rIEpq2ZRdBXnHDhDoj6YmMCge3OCbRFGuwMuN+oZXypiaD1tesSP4Nu9Ot9bic6+kc
         pWLF3VzXWBARb6aK4RDyhpd2R9LHV4rtfLPtEeLkJpq8kI7WfisR+sSz1rjg8pQtCBqE
         Pif7UkrovxKp41dDunMz7pAMS5yxKbz3PwW2I=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, pe1dnn@amsat.org,
       ext-andriy.shevchenko@nokia.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] [updated] [staging-next] Staging: wlags49_h2: fixed C99 comments style issues in wl_profile.c
Date: Mon, 10 May 2010 22:18:24 +0530
Message-Id: <1273510104-5014-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wl_profile.c file that fixes the C99 comments
style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/wlags49_h2/wl_profile.c |   54 +++++++++++++++---------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_profile.c b/drivers/staging/wlags49_h2/wl_profile.c
index 13ade70..292d579 100644
--- a/drivers/staging/wlags49_h2/wl_profile.c
+++ b/drivers/staging/wlags49_h2/wl_profile.c
@@ -91,7 +91,7 @@
 
 #include <debug.h>
 #include <hcf.h>
-//#include <hcfdef.h>
+/* #include <hcfdef.h> */
 
 #include <wl_if.h>
 #include <wl_internal.h>
@@ -118,17 +118,17 @@ int parse_yes_no(char *value);
 
 int parse_yes_no(char *value)
 {
-int rc = 0;										//default to NO for invalid parameters
+int rc = 0;										/* default to NO for invalid parameters */
 
 	if (strlen(value) == 1) {
 		if ((value[0] | ('Y'^'y')) == 'y')
 			rc = 1;
-//	} else {
-//		this should not be debug time info, it is an enduser data entry error ;?
-//		DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MICROWAVE_ROBUSTNESS);
+	/* } else { */
+		/* this should not be debug time info, it is an enduser data entry error ;? */
+		/* DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MICROWAVE_ROBUSTNESS); */
 	}
 	return rc;
-} // parse_yes_no
+} /* parse_yes_no */
 
 
 /*******************************************************************************
@@ -154,10 +154,10 @@ int rc = 0;										//default to NO for invalid parameters
 void parse_config(struct net_device *dev)
 {
 	int				    file_desc;
-#if 0 // BIN_DL
+#if 0 /* BIN_DL */
 	int				rc;
 	char				*cp = NULL;
-#endif // BIN_DL
+#endif /* BIN_DL */
 	char                buffer[MAX_LINE_SIZE];
 	char                filename[MAX_LINE_SIZE];
 	mm_segment_t	    fs;
@@ -192,7 +192,7 @@ void parse_config(struct net_device *dev)
 		while (readline(file_desc, buffer))
 			translate_option(buffer, wvlan_config);
 		/* Close the file */
-		close(file_desc);	//;?even if file_desc == -1 ???
+		close(file_desc);	/* ;?even if file_desc == -1 ??? */
 	} else {
 		DBG_TRACE(DbgInfo, "No iwconfig file found for this device; "
 				   "config.opts or wireless.opts will be used\n");
@@ -235,19 +235,19 @@ void parse_config(struct net_device *dev)
 	memcpy(&wvlan_config->DefaultKeys, &sEncryption.EncStr,
 			sizeof(CFG_DEFAULT_KEYS_STRCT));
 
-#if 0 //BIN_DL
+#if 0 /* BIN_DL */
 		/* Obtain a user-space process context, storing the original context */
 		fs = get_fs();
 		set_fs(get_ds());
 
-		//;?just to fake something
+		/* ;?just to fake something */
 		strcpy(/*wvlan_config->fw_image_*/filename, "/etc/agere/fw.bin");
 		file_desc = open(/*wvlan_config->fw_image_*/filename, 0, 0);
 		if (file_desc == -1) {
 			DBG_ERROR(DbgInfo, "No image file found\n");
 		} else {
 			DBG_TRACE(DbgInfo, "F/W image file found\n");
-#define DHF_ALLOC_SIZE 96000			//just below 96K, let's hope it suffices for now and for the future
+#define DHF_ALLOC_SIZE 96000			/* just below 96K, let's hope it suffices for now and for the future */
 			cp = (char *)vmalloc(DHF_ALLOC_SIZE);
 			if (cp == NULL) {
 				DBG_ERROR(DbgInfo, "error in vmalloc\n");
@@ -270,11 +270,11 @@ void parse_config(struct net_device *dev)
 			close(file_desc);
 		}
 		set_fs(fs);			/* Return to the original context */
-#endif // BIN_DL
+#endif /* BIN_DL */
 
 	DBG_LEAVE(DbgInfo);
 	return;
-} // parse_config
+} /* parse_config */
 
 /*******************************************************************************
  *	readline()
@@ -322,7 +322,7 @@ int readline(int filedesc, char *buffer)
 		return result;
 	else
 		return bytes_read;
-} // readline
+} /* readline */
 /*============================================================================*/
 
 /*******************************************************************************
@@ -381,9 +381,9 @@ void translate_option(char *buffer, struct wl_private *lp)
 				DbgInfo->DebugFlag |= DBG_DEFAULTS;
 			}
 		} else {
-			DbgInfo->DebugFlag = simple_strtoul(value, NULL, 0); //;?DebugFlag;
+			DbgInfo->DebugFlag = simple_strtoul(value, NULL, 0); /* ;?DebugFlag; */
 		}
-		DbgInfo->DebugFlag = simple_strtoul(value, NULL, 0); //;?Delete ASAP
+		DbgInfo->DebugFlag = simple_strtoul(value, NULL, 0); /* ;?Delete ASAP */
 	}
 #endif /* DBG */
 	if (strcmp(key, PARM_NAME_AUTH_KEY_MGMT_SUITE) == 0) {
@@ -602,10 +602,10 @@ void translate_option(char *buffer, struct wl_private *lp)
 	/* Need to add? : Country code, Short/Long retry */
 
 	/* Configuration parameters specific to STA mode */
-#if 1 //;? (HCF_TYPE) & HCF_TYPE_STA
-//;?seems reasonable that even an AP-only driver could afford this small additional footprint
+#if 1 /* ;? (HCF_TYPE) & HCF_TYPE_STA */
+/* ;?seems reasonable that even an AP-only driver could afford this small additional footprint */
 	if (CNV_INT_TO_LITTLE(lp->hcfCtx.IFB_FWIdentity.comp_id) == COMP_ID_FW_STA) {
-					//;?should we return an error status in AP mode
+					/* ;?should we return an error status in AP mode */
 		if (strcmp(key, PARM_NAME_PORT_TYPE) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_PORT_TYPE, value);
 
@@ -625,7 +625,7 @@ void translate_option(char *buffer, struct wl_private *lp)
 				lp->PMEnabled = value_convert;
 			} else {
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_PM_ENABLED);
-				//;?this is a data entry error, hence not a DBG_WARNING
+				/* ;?this is a data entry error, hence not a DBG_WARNING */
 			}
 		} else if (strcmp(key, PARM_NAME_CREATE_IBSS) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_CREATE_IBSS, value);
@@ -690,8 +690,8 @@ void translate_option(char *buffer, struct wl_private *lp)
 #endif  /* (HCF_TYPE) & HCF_TYPE_STA */
 
 	/* Configuration parameters specific to AP mode */
-#if 1 //;? (HCF_TYPE) & HCF_TYPE_AP
-		//;?should we restore this to allow smaller memory footprint
+#if 1 /* ;? (HCF_TYPE) & HCF_TYPE_AP */
+		/* ;?should we restore this to allow smaller memory footprint */
 	if (CNV_INT_TO_LITTLE(lp->hcfCtx.IFB_FWIdentity.comp_id) == COMP_ID_FW_AP) {
 		if (strcmp(key, PARM_NAME_OWN_DTIM_PERIOD) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_OWN_DTIM_PERIOD, value);
@@ -876,7 +876,7 @@ void translate_option(char *buffer, struct wl_private *lp)
 #endif  /* (HCF_TYPE) & HCF_TYPE_AP */
 
 	return;
-} // translate_option
+} /* translate_option */
 /*============================================================================*/
 
 /*******************************************************************************
@@ -932,7 +932,7 @@ int parse_mac_address(char *value, u_char *byte_array)
 	/* Use the array_offset as a check; 6 bytes should be written to the
 	   byte_array */
 	return array_offset;
-} // parse_mac_address
+} /* parse_mac_address */
 /*============================================================================*/
 
 /*******************************************************************************
@@ -1006,7 +1006,7 @@ void ParseConfigLine(char *pszLine, char **ppszLVal, char **ppszRVal)
 		}
 	}
 	DBG_LEAVE(DbgInfo);
-} // ParseConfigLine
+} /* ParseConfigLine */
 /*============================================================================*/
 
-#endif  // USE_PROFILE
+#endif  /* USE_PROFILE */
-- 
1.6.0.4

