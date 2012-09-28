Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422858Ab2I1VZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:25:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab2I1U33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 147/218] drm/radeon/ss: use num_crtc rather than hardcoded 6
Date: Fri, 28 Sep 2012 13:16:04 -0700
Message-Id: <20120928201518.355979426@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5317670692f61675394db2eb6713484b67383750 upstream.

When checking if a pll is in use.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -452,7 +452,7 @@ static void atombios_crtc_program_ss(str
 	union atom_enable_ss args;
 
 	if (!enable) {
-		for (i = 0; i < 6; i++) {
+		for (i = 0; i < rdev->num_crtc; i++) {
 			if (rdev->mode_info.crtcs[i] &&
 			    rdev->mode_info.crtcs[i]->enabled &&
 			    i != crtc_id &&


