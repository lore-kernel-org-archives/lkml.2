Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0KFQXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:23:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46788 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0KFQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OM4ZVePEuclX8E10MV/fQp3CYkQZVEkc6+Td/s2j3EhU2uq+SJKwK1yaRpV0//BSTW
         tWb0f2Ac9Ae9/OgH25KUVMKmw+XvsFNFDiUD4H5bV2PBne2BWL4OpxeFlUyvBgh1zYOD
         xHErBOtEHAJNLFDfGuIdNOorBThUZUG6M4gso=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, greg@kroah.com, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] Staging: wlan-ng: fix coding style issues in prism2mib.c
Date: Sat,  6 Nov 2010 18:23:27 +0200
Message-Id: <1289060607-13840-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the prism2mib.c file that fixes various coding style issues that were found by the checkpatch.pl tool

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlan-ng/prism2mib.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index d3a06fa..c1276fd 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -136,7 +136,8 @@ static int prism2mib_fragmentationthreshold(struct mibrec *mib,
 					    int isget,
 					    wlandevice_t *wlandev,
 					    hfa384x_t *hw,
-					    struct p80211msg_dot11req_mibset *msg,
+					    struct p80211msg_dot11req_mibset
+						*msg,
 					    void *data);
 
 static int prism2mib_priv(struct mibrec *mib,
@@ -664,7 +665,8 @@ static int prism2mib_fragmentationthreshold(struct mibrec *mib,
 					    int isget,
 					    wlandevice_t *wlandev,
 					    hfa384x_t *hw,
-					    struct p80211msg_dot11req_mibset *msg,
+					    struct p80211msg_dot11req_mibset
+						*msg,
 					    void *data)
 {
 	int result;
-- 
1.7.1

