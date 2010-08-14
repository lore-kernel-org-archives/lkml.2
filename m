Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0HNQm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:42:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33927 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab0HNQmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qdft/k2pfdkRY0jT1JrWOEkHoKgL0KeY5lk9SyK5tn6dTaOKzBnbM/PtNxlNp3Lcds
         MvmLtClCNy5aB61sJlDqiL2WFlFmMzrH6HKJxGaP6GqujKpl9hXkgbfMzUS+yTk+sjIl
         gTDMcfQHJRkTDXa+rH/qNdYcMPo4QxR6VokcU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/2]drivers/video/vesafb.c Fix a typo.
Date: Sat, 14 Aug 2010 09:43:21 -0700
Message-Id: <1281804202-27500-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a typo or not i.e. using a dictionary online 
gives no results for "ressource", but doing a search for "ressource"
I get a wikepedia entry. In any case if it is a typo, then heres 
a patch to fix it, if not, then I'll add this patch to my
NACK pile...

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/video/vesafb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 090aa1a..6a069d0 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -253,7 +253,7 @@ static int __init vesafb_probe(struct platform_device *dev)
 	size_vmode = vesafb_defined.yres * vesafb_fix.line_length;
 
 	/*   size_total -- all video memory we have. Used for mtrr
-	 *                 entries, ressource allocation and bounds
+	 *                 entries, resource allocation and bounds
 	 *                 checking. */
 	size_total = screen_info.lfb_size * 65536;
 	if (vram_total)
-- 
1.7.1.rc1.21.gf3bd6

