Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2HFUDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:03:09 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:46775 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab2HFUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:03:07 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] extcon: fixing typos
Date: Mon,  6 Aug 2012 22:03:03 +0200
Message-Id: <1344283383-11033-2-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344283383-11033-1-git-send-email-pmeerw@pmeerw.net>
References: <1344283383-11033-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/extcon/extcon_class.c |    8 ++++----
 include/linux/extcon.h        |   18 +++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index f6419f9..fa56339 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -442,7 +442,7 @@ static int _call_per_cable(struct notifier_block *nb, unsigned long val,
 
 /**
  * extcon_register_interest() - Register a notifier for a state change of a
- *			      specific cable, not a entier set of cables of a
+ *			      specific cable, not an entire set of cables of a
  *			      extcon device.
  * @obj:	an empty extcon_specific_cable_nb object to be returned.
  * @extcon_name:	the name of extcon device.
@@ -498,7 +498,7 @@ int extcon_unregister_interest(struct extcon_specific_cable_nb *obj)
 }
 
 /**
- * extcon_register_notifier() - Register a notifee to get notified by
+ * extcon_register_notifier() - Register a notifiee to get notified by
  *			      any attach status changes from the extcon.
  * @edev:	the extcon device.
  * @nb:		a notifier block to be registered.
@@ -515,7 +515,7 @@ int extcon_register_notifier(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_register_notifier);
 
 /**
- * extcon_unregister_notifier() - Unregister a notifee from the extcon device.
+ * extcon_unregister_notifier() - Unregister a notifiee from the extcon device.
  * @edev:	the extcon device.
  * @nb:		a registered notifier block to be unregistered.
  */
@@ -802,7 +802,7 @@ EXPORT_SYMBOL_GPL(extcon_dev_register);
 
 /**
  * extcon_dev_unregister() - Unregister the extcon device.
- * @edev:	the extcon device instance to be unregitered.
+ * @edev:	the extcon device instance to be unregistered.
  *
  * Note that this does not call kfree(edev) because edev was not allocated
  * by this class.
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index cdd4014..a6888e2 100644
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
+ * Registar gets notified for every external port of a connection device.
  * Probably this could be used to debug an action of notifier; however,
- * we do not recommend to use this at normal 'notifiee' device drivers who
+ * we do not recommend to use this for normal 'notifiee' device drivers who
  * want to be notified by a specific external port of the notifier.
  */
 extern int extcon_register_notifier(struct extcon_dev *edev,
-- 
1.7.9.5

