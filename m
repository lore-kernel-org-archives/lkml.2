Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab0G3Sqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:46:42 -0400
Received: from kroah.org ([198.145.64.141]:35791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759419Ab0G3Reu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:08 2010
Message-Id: <20100730173108.136169243@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [060/140] drm/radeon/kms: fix legacy tv-out pal mode
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit ff3f011cd859072b5d6e64c0b968cff9bfdc0b37 upstream.

fixes fdo bug 26915

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_legacy_tv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_legacy_tv.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
@@ -642,8 +642,8 @@ void radeon_legacy_tv_mode_set(struct dr
 	}
 	flicker_removal = (tmp + 500) / 1000;
 
-	if (flicker_removal < 2)
-		flicker_removal = 2;
+	if (flicker_removal < 3)
+		flicker_removal = 3;
 	for (i = 0; i < ARRAY_SIZE(SLOPE_limit); ++i) {
 		if (flicker_removal == SLOPE_limit[i])
 			break;


