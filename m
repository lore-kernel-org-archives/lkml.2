Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1G1Xs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:48:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:25230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab1G1Xoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="35732461"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: hans.verkuil@cisco.com, mchehab@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [34/50] bttv: fix s_tuner for radio
Message-Id: <20110728234438.E15E52403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hans Verkuil <hans.verkuil@cisco.com>

[ upstream commit a024c1a6b274e11596d124619e43c25560f64c01 ]

Fix typo: g_tuner should have been s_tuner.

Tested with a bttv card.

Cc: stable@kernel.org
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/bt8xx/bttv-driver.c
+++ linux-2.6.35.y/drivers/media/video/bt8xx/bttv-driver.c
@@ -3525,7 +3525,7 @@ static int radio_s_tuner(struct file *fi
 	if (0 != t->index)
 		return -EINVAL;
 
-	bttv_call_all(btv, tuner, g_tuner, t);
+	bttv_call_all(btv, tuner, s_tuner, t);
 	return 0;
 }
 
