Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1DHPDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:03:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456Ab1DHPCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:02:36 -0400
From: Michal Marek <mmarek@suse.cz>
To: mjg@redhat.com
Cc: gregkh@suse.de, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] samsung-laptop: set backlight type
Date: Fri,  8 Apr 2011 17:02:05 +0200
Message-Id: <1302274926-25985-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302274926-25985-1-git-send-email-mmarek@suse.cz>
References: <1302274926-25985-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cherry-picked from drivers/staging/samsung-laptop/samsung-laptop.c

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/platform/x86/samsung-laptop.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 39f30ff..d347116 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -781,6 +781,7 @@ static int __init samsung_init(void)
 
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = sabi_config->max_brightness;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
-- 
1.7.4.1

