Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab0CSC0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:26:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50970 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0CSC0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ql6qG3RGBmqo8wVrqk2OzaiBfGMYAaUagACCA4F/jl+cQjdPIkhgDjiD9/KUgNJDYk
         /Ve30/HTRD+/qt+GGBSegSk6iJMkBQfSEqoTeN+J9/XpKSiLZoJscaJf2mYHGXF9Pfs+
         XpsJFTCuaQqI1mt/b2hT43dfdSPF58B6lXxSc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Fix a typo in sound/pci/hda/hda_local.h
Date: Thu, 18 Mar 2010 19:26:13 -0700
Message-Id: <1268965573-11829-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this should be automatic pin instead of ping.
(but could be wrong).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 sound/pci/hda/hda_local.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index 7cee364..7a97f12 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -361,7 +361,7 @@ struct hda_bus_unsolicited {
 };
 
 /*
- * Helper for automatic ping configuration
+ * Helper for automatic pin configuration
  */
 
 enum {
-- 
1.6.5.GIT

