Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0DVTxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:53:24 -0400
Received: from kroah.org ([198.145.64.141]:40846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab0DVT2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:39 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.083619626@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [086/197] drm/edid/quirks: Envision EN2028
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit ba1163de2f74d624e7b0e530c4104c98ede0045a upstream.

Claims 1280x1024 preferred, physically 1600x1200

cf. http://bugzilla.redhat.com/530399

Signed-off-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_edid.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -85,6 +85,8 @@ static struct edid_quirk {
 
 	/* Envision Peripherals, Inc. EN-7100e */
 	{ "EPI", 59264, EDID_QUIRK_135_CLOCK_TOO_HIGH },
+	/* Envision EN2028 */
+	{ "EPI", 8232, EDID_QUIRK_PREFER_LARGE_60 },
 
 	/* Funai Electronics PM36B */
 	{ "FCM", 13600, EDID_QUIRK_PREFER_LARGE_75 |


