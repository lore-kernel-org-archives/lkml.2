Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab2HWAMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 20:12:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25685 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2HWAL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 20:11:59 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-d3-5035754d1656
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: pmeerw@pmeerw.net, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, trivial@kernelg.org
Subject: [PATCH 4/4] extcon: fixing typos
Date: Thu, 23 Aug 2012 09:11:54 +0900
Message-id: <1345680714-5974-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAV3fUtMAgyc/tSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGo/urWAomaFc8bnzO2MB4QKmLkZNDQsBE4uHVRSwQtpjEhXvr
	2boYuTiEBBYxSvTNfMcO4Sxlkli4ewUzSBWbgJbE/hc32EBsEQE5iSe3/4DFmQXqJebvmMcI
	YgsLaEpcvvmbFcRmEVCVuPF/CROIzSvgInGq8QUTxDYFidZlh9gnMHIvYGRYxSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iRHsw2fSOxhXNVgcYhTgYFTi4c2INQ0QYk0sK67MPcQowcGsJMLb
	VQQU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzsvfZxggJJCeWJKanZpakFoEk2Xi4JRqYJy+8NBt
	JadDAS38Ki6+Mvs+PF+6rD/Qm4+7NPvYs79CVdOXl18o9X8xz2afe/5PxlIP46uF9ZNVV7K8
	ilCSvLI1mvf+F6OiqiNfX6xk1HsxVTNRROSju0Xiun9OW1oFLi45WrUyZ6vlxP+fyyY92Mjt
	XPTbvbB95SWFi9dO/vTfyrdv4bPo3zeUWIozEg21mIuKEwGvFcVs3QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-class.c |    8 ++++----
 include/linux/extcon.h        |   18 +++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 481cfa0..946a318 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -443,7 +443,7 @@ static int _call_per_cable(struct notifier_block *nb, unsigned long val,
 
 /**
  * extcon_register_interest() - Register a notifier for a state change of a
- *			      specific cable, not a entier set of cables of a
+ *			      specific cable, not an entier set of cables of a
  *			      extcon device.
  * @obj:	an empty extcon_specific_cable_nb object to be returned.
  * @extcon_name:	the name of extcon device.
@@ -499,7 +499,7 @@ int extcon_unregister_interest(struct extcon_specific_cable_nb *obj)
 }
 
 /**
- * extcon_register_notifier() - Register a notifee to get notified by
+ * extcon_register_notifier() - Register a notifiee to get notified by
  *			      any attach status changes from the extcon.
  * @edev:	the extcon device.
  * @nb:		a notifier block to be registered.
@@ -516,7 +516,7 @@ int extcon_register_notifier(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_register_notifier);
 
 /**
- * extcon_unregister_notifier() - Unregister a notifee from the extcon device.
+ * extcon_unregister_notifier() - Unregister a notifiee from the extcon device.
  * @edev:	the extcon device.
  * @nb:		a registered notifier block to be unregistered.
  */
@@ -806,7 +806,7 @@ EXPORT_SYMBOL_GPL(extcon_dev_register);
 
 /**
  * extcon_dev_unregister() - Unregister the extcon device.
- * @edev:	the extcon device instance to be unregitered.
+ * @edev:	the extcon device instance to be unregistered.
  *
  * Note that this does not call kfree(edev) because edev was not allocated
  * by this class.
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index cdd4014..7443a56 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -30,19 +30,19 @@
 
 /*
  * The standard cable name is to help support general notifier
- * and notifee device drivers to share the common names.
+ * and notifiee device drivers to share the common names.
  * Please use standard cable names unless your notifier device has
  * a very unique and abnormal cable or
  * the cable type is supposed to be used with only one unique
- * pair of notifier/notifee devices.
+ * pair of notifier/notifiee devices.
  *
  * Please add any other "standard" cables used with extcon dev.
  *
  * You may add a dot and number to specify version or specification
  * of the specific cable if it is required. (e.g., "Fast-charger.18"
  * and "Fast-charger.10" for 1.8A and 1.0A chargers)
- * However, the notifee and notifier should be able to handle such
- * string and if the notifee can negotiate the protocol or idenify,
+ * However, the notifiee and notifier should be able to handle such
+ * string and if the notifiee can negotiate the protocol or identify,
  * you don't need such convention. This convention is helpful when
  * notifier can distinguish but notifiee cannot.
  */
@@ -76,7 +76,7 @@ struct extcon_cable;
  * struct extcon_dev - An extcon device represents one external connector.
  * @name	The name of this extcon device. Parent device name is used
  *		if NULL.
- * @supported_cable	Array of supported cable name ending with NULL.
+ * @supported_cable	Array of supported cable names ending with NULL.
  *			If supported_cable is NULL, cable name related APIs
  *			are disabled.
  * @mutually_exclusive	Array of mutually exclusive set of cables that cannot
@@ -95,7 +95,7 @@ struct extcon_cable;
  * @state	Attach/detach state of this extcon. Do not provide at
  *		register-time
  * @nh	Notifier for the state change events from this extcon
- * @entry	To support list of extcon devices so that uses can search
+ * @entry	To support list of extcon devices so that users can search
  *		for extcon devices based on the extcon name.
  * @lock
  * @max_supported	Internal value to store the number of cables.
@@ -199,7 +199,7 @@ extern int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
 /*
  * get/set_cable_state access each bit of the 32b encoded state value.
  * They are used to access the status of each cable based on the cable_name
- * or cable_index, which is retrived by extcon_find_cable_index
+ * or cable_index, which is retrieved by extcon_find_cable_index
  */
 extern int extcon_find_cable_index(struct extcon_dev *sdev,
 				   const char *cable_name);
@@ -226,9 +226,9 @@ extern int extcon_unregister_interest(struct extcon_specific_cable_nb *nb);
 
 /*
  * Following APIs are to monitor every action of a notifier.
- * Registerer gets notified for every external port of a connection device.
+ * Registrar gets notified for every external port of a connection device.
  * Probably this could be used to debug an action of notifier; however,
- * we do not recommend to use this at normal 'notifiee' device drivers who
+ * we do not recommend to use this for normal 'notifiee' device drivers who
  * want to be notified by a specific external port of the notifier.
  */
 extern int extcon_register_notifier(struct extcon_dev *edev,
-- 
1.7.0.4

