Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab0JRQai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:30:38 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:33099 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750800Ab0JRQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:30:38 -0400
Subject: [PATCH] drm: include missing types header to drm_mode.h
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 13:30:28 -0300
Message-ID: <1287419428.7945.7.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm: include missing types header to drm_mode.h

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 include/drm/drm_mode.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 0fc7397..eddd7f4 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -24,6 +24,8 @@
  * IN THE SOFTWARE.
  */
 
+#include <linux/types.h>
+
 #ifndef _DRM_MODE_H
 #define _DRM_MODE_H
 
-- 
1.7.0.4



