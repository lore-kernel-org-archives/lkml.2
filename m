Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0KPRzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:55:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51172 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab0KPRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:55:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Iop8F9mXIxtoqKjT5NG46CuEBmXV+AN9OSCbowF16Y2p1QGk7Dqxq0Y0BqeQkk+NIJ
         eqNeXYb0V4Mzx2Klg+hm5Jr17nvEuXiJtmUF/+54v+wLDzwVEQd/hJGfU6RVBZwf22O4
         GV0Wo3Cv2T8MsCqA/u+mytvBVHOC1JYZGbbao=
From: Alessio Igor Bogani <abogani@texware.it>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tim Bird <tim.bird@am.sony.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] powerpc: Update a comment
Date: Tue, 16 Nov 2010 18:55:16 +0100
Message-Id: <1289930116-5702-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 5e3d20a remove bkl from startup code so setup_arch() it isn't called
with bkl held anymore. Update the comment on top of that function.
Fix also a typo.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 arch/powerpc/kernel/setup_64.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 2a178b0..ce6f61c 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -497,9 +497,8 @@ static void __init emergency_stack_init(void)
 }
 
 /*
- * Called into from start_kernel, after lock_kernel has been called.
- * Initializes bootmem, which is unsed to manage page allocation until
- * mem_init is called.
+ * Called into from start_kernel this initializes bootmem, which is used
+ * to manage page allocation until mem_init is called.
  */
 void __init setup_arch(char **cmdline_p)
 {
-- 
1.7.0.4

