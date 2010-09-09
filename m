Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0IIWZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:25:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45244 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab0IIWZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NkWCUVXNmL31lVL+k1RM6Qb2hLU0OhCw+stv7XdULL5B3xG4IZI1heXXc0UXGZVMuF
         VoY0t9Jku++zaKC8fj8f3Ys4bJztJXfVotezJoENtDWO7IVaU5FAwXvXkM8k5IPT/UzT
         4prHQ7WS0pVAoQX1hc5eX5WhGuoRRmeZkIlcs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 020/223]drivers/gpu/drm/drm_modes.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:25:39 -0700
Message-Id: <1284071149-7723-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
References: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/gpu/drm/drm_modes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 949326d..59251d2 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL(drm_mode_debug_printmodeline);
  * according to the hdisplay, vdisplay, vrefresh.
  * It is based from the VESA(TM) Coordinated Video Timing Generator by
  * Graham Loveridge April 9, 2003 available at
- * http://www.vesa.org/public/CVT/CVTd6r1.xls
+ * http://www.vesa.org/
  *
  * And it is copied from xf86CVTmode in xserver/hw/xfree86/modes/xf86cvt.c.
  * What I have done is to translate it by using integer calculation.
-- 
1.7.2.1

