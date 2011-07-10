Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1GJJ2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:28:47 -0400
Received: from mail.perches.com ([173.55.12.10]:3734 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab1GJJ2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:28:37 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 5/5] dbri: Add missing breaks in switch/case
Date: Sun, 10 Jul 2011 02:28:28 -0700
Message-Id: <5aa8ee111dd52768622e89c06440e1328f0d2247.1310289795.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1310289795.git.joe@perches.com>
References: <cover.1310289795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/sparc/dbri.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 73f9cba..ca978b1 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -578,14 +578,19 @@ static __u32 reverse_bytes(__u32 b, int len)
 	switch (len) {
 	case 32:
 		b = ((b & 0xffff0000) >> 16) | ((b & 0x0000ffff) << 16);
+		break;
 	case 16:
 		b = ((b & 0xff00ff00) >> 8) | ((b & 0x00ff00ff) << 8);
+		break;
 	case 8:
 		b = ((b & 0xf0f0f0f0) >> 4) | ((b & 0x0f0f0f0f) << 4);
+		break;
 	case 4:
 		b = ((b & 0xcccccccc) >> 2) | ((b & 0x33333333) << 2);
+		break;
 	case 2:
 		b = ((b & 0xaaaaaaaa) >> 1) | ((b & 0x55555555) << 1);
+		break;
 	case 1:
 	case 0:
 		break;
-- 
1.7.6.131.g99019

