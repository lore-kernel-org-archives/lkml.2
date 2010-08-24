Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab0HXX2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:28:46 -0400
Received: from kroah.org ([198.145.64.141]:40594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab0HXW7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:40 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:18 2010
Message-Id: <20100824224218.435188915@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [74/91] drm/radeon/kms: fix typo in radeon_compute_pll_gain
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 0537398b211b4f040564beec458e23571042d335 upstream.

Looks like this got copied from the ddx wrong.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -272,7 +272,7 @@ static uint8_t radeon_compute_pll_gain(u
 	if (!ref_div)
 		return 1;
 
-	vcoFreq = ((unsigned)ref_freq & fb_div) / ref_div;
+	vcoFreq = ((unsigned)ref_freq * fb_div) / ref_div;
 
 	/*
 	 * This is horribly crude: the VCO frequency range is divided into


