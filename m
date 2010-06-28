Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0F1L5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:57:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:29378 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0F1LzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GAoVuOmO4+lN5VnrQJYHEdkoois/8lH8k1gVK1WY3QfeMn1zI+hVy83d+TikChs69H
         U+fqzCVh5qZ9b/jhcnxbEIgUPO4MlaHVMm/NSUQuxEKXynNwrIhq6U1EqvvFa3zwJIvq
         ypdM99J+iRuouYgEyaM2JWiXgpi5JyQ+Km5sg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Ma Ling <ling.ma@intel.com>,
       Kulikov Vasiliy <segooon@gmail.com>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:00 +0400
Message-Id: <1277726101-24567-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/gpu/drm/i915/intel_tv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 6d553c2..d2d4e40 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1424,7 +1424,7 @@ intel_tv_get_modes(struct drm_connector *connector)
 	int j, count = 0;
 	u64 tmp;
 
-	for (j = 0; j < sizeof(input_res_table) / sizeof(input_res_table[0]);
+	for (j = 0; j < ARRAY_SIZE(input_res_table);
 	     j++) {
 		struct input_res *input = &input_res_table[j];
 		unsigned int hactive_s = input->w;
-- 
1.7.0.4

