Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1CGIZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:25:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60411 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1CGIVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=FccbBUp8v+zbyaSr3D+DO5hEJHQ2wSmdo1Q27aOC8yQOeHXDCNQfqbYgUj2CdaIDvz
         rez8x5QyJiR9GqHEshQYnsT4nw1Gicp4A2qSEOM18RMNDJ/dH7l1M4P2B2tUZAneJLXf
         lr9xytjrfv4K0adXj2iYyXq2485tWH5vVfzYo=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 06/21] staging: ft1000: Fix identation in ftnet_ops struct.
Date: Mon,  7 Mar 2011 09:21:11 +0100
Message-Id: <1299486086-7325-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 71c7c5d..bf2c729 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -688,10 +688,10 @@ static int ft1000_reset_card(struct net_device *dev)
 #ifdef HAVE_NET_DEVICE_OPS
 static const struct net_device_ops ftnet_ops =
 {
-.ndo_open = &ft1000_open,
-.ndo_stop = &ft1000_close,
-.ndo_start_xmit = &ft1000_start_xmit,
-.ndo_get_stats = &ft1000_netdev_stats,
+	.ndo_open = &ft1000_open,
+	.ndo_stop = &ft1000_close,
+	.ndo_start_xmit = &ft1000_start_xmit,
+	.ndo_get_stats = &ft1000_netdev_stats,
 };
 #endif
 
-- 
1.7.1

