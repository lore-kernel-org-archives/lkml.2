Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0IIXBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:01:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37652 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab0IIWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Wg7E8Pm5E9cViViobuIOeKq8r0Rcv8Axe/AU6KQUTLrA76dGq46L6qysKc+SxIV005
         ncXqxsPGVsKQCVj6x6suvqbLMpR952vVL6dKSVmYBTUIXs6BQrGx4EEq5+/jb432/O1O
         DdTl+r0rZNk+phmoNJmkq1izUPCMWiyrJN1B0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 109/223]drivers/net/acenic.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:38 -0700
Message-Id: <1284071809-8149-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/acenic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index b9a5916..ecfa01a 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -440,7 +440,7 @@ MODULE_PARM_DESC(tx_ratio, "AceNIC/3C985/GA620 ratio of NIC memory used for TX/R
 
 static const char version[] __devinitconst =
   "acenic.c: v0.92 08/05/2002  Jes Sorensen, linux-acenic@SunSITE.dk\n"
-  "                            http://home.cern.ch/~jes/gige/acenic.html\n";
+  "                            http://web.archive.org/web/20071219235833/jes.web.cern.ch/jes/gige/acenic.html\n";
 
 static int ace_get_settings(struct net_device *, struct ethtool_cmd *);
 static int ace_set_settings(struct net_device *, struct ethtool_cmd *);
-- 
1.7.2.1

