Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0KMHEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:04:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49259 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0KMHEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:04:13 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] fsl-diu-fb: drop dead ioctl define
Date: Sat, 13 Nov 2010 02:06:27 -0500
Message-Id: <1289631987-5854-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsl-diu-fb driver no longer uses this define, and we have a common one
to cover this already (FBIO_WAITFORVSYNC).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/fsl-diu-fb.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/fsl-diu-fb.h b/include/linux/fsl-diu-fb.h
index fc295d7..781d467 100644
--- a/include/linux/fsl-diu-fb.h
+++ b/include/linux/fsl-diu-fb.h
@@ -54,7 +54,6 @@ struct aoi_display_offset {
 };
 
 #define MFB_SET_CHROMA_KEY	_IOW('M', 1, struct mfb_chroma_key)
-#define MFB_WAIT_FOR_VSYNC	_IOW('F', 0x20, u_int32_t)
 #define MFB_SET_BRIGHTNESS	_IOW('M', 3, __u8)
 
 #define MFB_SET_ALPHA		0x80014d00
-- 
1.7.3.2

