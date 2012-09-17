Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2IQAuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33321 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab2IQAtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:23 -0400
Message-Id: <20120917003627.877990500@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adam Jackson <ajax@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 012/135] drm/i915: Fix assert_pch_hdmi_disabled to mention HDMI (not DP)
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit 23c99e775d14f01ba45a5affd2fb51af4328359c upstream.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d775f95..3e21f3c 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1096,7 +1096,7 @@ static void assert_pch_hdmi_disabled(struct drm_i915_private *dev_priv,
 {
 	u32 val = I915_READ(reg);
 	WARN(hdmi_pipe_enabled(dev_priv, val, pipe),
-	     "PCH DP (0x%08x) enabled on transcoder %c, should be disabled\n",
+	     "PCH HDMI (0x%08x) enabled on transcoder %c, should be disabled\n",
 	     reg, pipe_name(pipe));
 }
 


