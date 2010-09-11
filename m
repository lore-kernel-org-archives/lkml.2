Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0IKFz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:55:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50217 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0IKFzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I1BdRh56wo2eJwOvR596mGQJxzNCkQ5GtZYWx4XsCEugePayXK3547nAd0Vqrpg1A7
         gTOhFLq1tBD5wYU4lbvNbXMFs/lJsFOECwS2RoPlymSO/DdyrZ29NPe32UL9d5dvevK8
         h+beej+Q1c/dUC/rxEbiTDZl9kvLp0bd9c7Oc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]scripts/kconfig/gconf.glade Update broken web addresses.
Date: Fri, 10 Sep 2010 22:56:24 -0700
Message-Id: <1284184584-8647-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below fixes a broken web address. Note: not sure if this is correct
or not.. Let me know..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 scripts/kconfig/gconf.glade |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
index d52b0a7..8092dcf 100644
--- a/scripts/kconfig/gconf.glade
+++ b/scripts/kconfig/gconf.glade
@@ -1,5 +1,5 @@
 <?xml version="1.0" standalone="no"?> <!--*- mode: xml -*-->
-<!DOCTYPE glade-interface SYSTEM "http://glade.gnome.org/glade-2.0.dtd">
+<!DOCTYPE glade-interface SYSTEM "http://library.gnome.org/devel/libglade/unstable/libglade-dtd.html">
 
 <glade-interface>
 
-- 
1.7.2.1

