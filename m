Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1CUXRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:17:52 -0400
Received: from kroah.org ([198.145.64.141]:52553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1CUXRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:23 2011
Message-Id: <20110321230323.398806390@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [17/78] drm/radeon/kms: fix typo in atom overscan setup
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 942b0e95c34f1ba432d08e1c0288ed032d32c3b2 upstream.

Typo in the aspect scale setup.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -61,8 +61,8 @@ static void atombios_overscan_setup(stru
 			args.usOverscanLeft = cpu_to_le16((adjusted_mode->crtc_hdisplay - (a2 / mode->crtc_vdisplay)) / 2);
 			args.usOverscanRight = cpu_to_le16((adjusted_mode->crtc_hdisplay - (a2 / mode->crtc_vdisplay)) / 2);
 		} else if (a2 > a1) {
-			args.usOverscanLeft = cpu_to_le16((adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2);
-			args.usOverscanRight = cpu_to_le16((adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2);
+			args.usOverscanTop = cpu_to_le16((adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2);
+			args.usOverscanBottom = cpu_to_le16((adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2);
 		}
 		break;
 	case RMX_FULL:


