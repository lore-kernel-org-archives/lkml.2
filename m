Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0JOPOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:14:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0JOPOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=h0TuSqoiX2h1N4qWoVqAQVfRv6zLHcshHkELMSnraY/jWo+OpIjEKAxWF/knjOq1sy
         MODMhnrXW1OujZqLOfkmf8PUboNEL5BNz6UDN1DRvwNy+JH0FKNcCn3PT0qovoC8P5Bg
         02Me26Kpqno6GGBszRHw5JzkTRbBHk0oSoJLk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, David Airlie <airlied@linux.ie>,
        Eric Anholt <eric@anholt.net>, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 04/13] drivers: gpu: drm: i915: Fix a typo.
Date: Fri, 15 Oct 2010 17:14:33 +0200
Message-Id: <1287155673-11418-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.3.1.181.g784b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"userpace" -> "userspace"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/gpu/drm/i915/i915_irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 85785a8..5c688b7 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -620,7 +620,7 @@ static void i915_capture_error_state(struct drm_device *dev)
 	}
 
 	/* We need to copy these to an anonymous buffer as the simplest
-	 * method to avoid being overwritten by userpace.
+	 * method to avoid being overwritten by userspace.
 	 */
 	error->batchbuffer[0] = i915_error_object_create(dev, batchbuffer[0]);
 	error->batchbuffer[1] = i915_error_object_create(dev, batchbuffer[1]);
-- 
1.7.2.1.85.g2d089

