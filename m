Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1HMA0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:26:47 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45575 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1HMA0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:26:43 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/4]sound:pci Fix typo "shud"
Date: Fri, 12 Aug 2011 17:26:14 -0700
Message-Id: <1313195174-4464-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
References: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes a typo shud.

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
+/* A3D base support init/shutown */
 static void __devinit vortex_Vort3D_enable(vortex_t * v)
 {
 	int i;
-- 
1.7.6

