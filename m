Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab0JVS44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:56 -0400
Received: from kroah.org ([198.145.64.141]:34289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439Ab0JVS4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:47 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.469269314@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [068/103] drm/radeon/kms: fix up encoder info messages for DFP6
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 73758a5d51280ca0613b8380fc07351f4d64f9c8 upstream.

encoder info was not printed properly on boards using the
DFP6 id.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_display.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -349,6 +349,8 @@ static void radeon_print_display_setup(s
 					DRM_INFO("    DFP4: %s\n", encoder_names[radeon_encoder->encoder_id]);
 				if (devices & ATOM_DEVICE_DFP5_SUPPORT)
 					DRM_INFO("    DFP5: %s\n", encoder_names[radeon_encoder->encoder_id]);
+				if (devices & ATOM_DEVICE_DFP6_SUPPORT)
+					DRM_INFO("    DFP6: %s\n", encoder_names[radeon_encoder->encoder_id]);
 				if (devices & ATOM_DEVICE_TV1_SUPPORT)
 					DRM_INFO("    TV1: %s\n", encoder_names[radeon_encoder->encoder_id]);
 				if (devices & ATOM_DEVICE_CV_SUPPORT)


