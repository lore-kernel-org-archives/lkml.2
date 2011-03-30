Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1C3JSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:18:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51173 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932150Ab1C3JSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:18:41 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 06/18] gma500: Makefiles
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 09:59:57 +0100
Message-ID: <20110330085951.5897.13551.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build the new files now all the changes they need are present. They won't
yet be used but the plumbing is next step.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index a52ba48..383a574 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -26,6 +26,8 @@ psb_gfx-y += psb_bl.o \
 	  psb_ttm_fence_user.o \
 	  psb_ttm_placement_user.o \
 	  psb_powermgmt.o \
-	  psb_irq.o
+	  psb_irq.o \
+	  mrst_crtc.o \
+	  mrst_lvds.o
 
 obj-$(CONFIG_DRM_PSB) += psb_gfx.o

