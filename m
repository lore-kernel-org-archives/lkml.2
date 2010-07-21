Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0GUE4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:56:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762204Ab0GUEzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ofWjKtK94zwrccsYmMOozmlt1THxn4lyEtP29sGoCgg/V0iBui/6hcvRGUGNxExe1+
         cwDKZNawZgPJw7rpAY3GlE0Xs/G1y1LGCBvShMRIE2e6QeQN8Soq+jaA7m5KxLIlT/kt
         vu3Cohxw4KvjwgLAj7vZSJgBw5rC4wmuRUps8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 74/74]Documentation/networking/iphase.txt update web address.
Date: Tue, 20 Jul 2010 21:54:55 -0700
Message-Id: <1279688096-29519-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address to the best of
my knowledge.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/iphase.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/iphase.txt b/Documentation/networking/iphase.txt
index 55eac4a..670b72f 100644
--- a/Documentation/networking/iphase.txt
+++ b/Documentation/networking/iphase.txt
@@ -22,7 +22,7 @@ The features and limitations of this driver are as follows:
     - All variants of Interphase ATM PCI (i)Chip adapter cards are supported, 
       including x575 (OC3, control memory 128K , 512K and packet memory 128K, 
       512K and 1M), x525 (UTP25) and x531 (DS3 and E3). See 
-      http://www.iphase.com/site/iphase-web/?epi_menuItemID=e196f04b4b3b40502f150882e21046a0
+      http://www.iphase.com/
       for details.
     - Only x86 platforms are supported.
     - SMP is supported.
-- 
1.7.1.rc1.21.gf3bd6

