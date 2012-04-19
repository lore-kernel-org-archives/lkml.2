Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab2DSWBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:01:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2DSVFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:05:11 -0400
Message-Id: <20120419210303.745394838@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 07/75] drm/i915: make rc6 module parameter read-only
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit f57f9c167af7cb3fd315e6a8ebe194a8aea0832a upstream.

People have been getting confused and thinking this is a runtime control.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(semaphores,
 		"Use semaphores for inter-ring sync (default: -1 (use per-chip defaults))");
 
 int i915_enable_rc6 __read_mostly = -1;
-module_param_named(i915_enable_rc6, i915_enable_rc6, int, 0600);
+module_param_named(i915_enable_rc6, i915_enable_rc6, int, 0400);
 MODULE_PARM_DESC(i915_enable_rc6,
 		"Enable power-saving render C-state 6 (default: -1 (use per-chip default)");
 


