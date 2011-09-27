Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1I0GNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:13:24 -0400
Received: from home.keithp.com ([63.227.221.253]:55057 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab1I0GMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:05 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 4/9] drm/i915: Document a few more BDB_GENERAL_FEATURES bits from PCH BIOS
Date: Mon, 26 Sep 2011 23:11:41 -0700
Message-Id: <1317103906-4649-5-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes whether an eDP panel is present, and whether that should
use SSC (and at what frequency)

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_bios.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_bios.h b/drivers/gpu/drm/i915/intel_bios.h
index 02b1b624..72fb500 100644
--- a/drivers/gpu/drm/i915/intel_bios.h
+++ b/drivers/gpu/drm/i915/intel_bios.h
@@ -135,7 +135,10 @@ struct bdb_general_features {
         /* bits 5 */
 	u8 int_crt_support:1;
 	u8 int_tv_support:1;
-	u8 rsvd11:6; /* finish byte */
+	u8 int_efp_support:1;
+	u8 dp_ssc_enb:1;	/* PCH attached eDP supports SSC */
+	u8 dp_ssc_freq:1;	/* SSC freq for PCH attached eDP */
+	u8 rsvd11:3; /* finish byte */
 } __attribute__((packed));
 
 /* pre-915 */
-- 
1.7.6.3

