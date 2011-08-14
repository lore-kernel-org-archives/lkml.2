Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1HNBhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 21:37:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37490 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1HNBhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 21:37:32 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH V2 4/4]sound:pci Fix typo "shud"
Date: Sat, 13 Aug 2011 18:37:04 -0700
Message-Id: <1313285824-1892-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313285824-1892-1-git-send-email-justinmattock@gmail.com>
References: <1313285824-1892-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

This patch is a resend from the original, since I re-created a new typo
my mistake.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/pci/au88x0/au88x0_a3d.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/au88x0/au88x0_a3d.c b/sound/pci/au88x0/au88x0_a3d.c
index 9ae8b3b..bae67c2 100644
--- a/sound/pci/au88x0/au88x0_a3d.c
+++ b/sound/pci/au88x0/au88x0_a3d.c
@@ -593,7 +593,7 @@ static int Vort3DRend_Initialize(vortex_t * v, unsigned short mode)
 
 static int vortex_a3d_register_controls(vortex_t * vortex);
 static void vortex_a3d_unregister_controls(vortex_t * vortex);
-/* A3D base support init/shudown */
+/* A3D base support init/shutdown */
 static void __devinit vortex_Vort3D_enable(vortex_t * v)
 {
 	int i;
-- 
1.7.6

