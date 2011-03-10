Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1CJKzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:55:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52950 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1CJKvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PgT1WM/0RRPUSqvd7D8/+Xpb7pvWUHs1ygRfUzryF1trIOAxyE47uNWFShVFpWoLO2
         dJS31OXv1mXwbOX8BRCnc1NkgCGHj4/nqj5Lq/UNQYHeBPWKqE+g3rVRAUOVHe7Go3Lc
         tRw/4pe1RN7fDUyydCC5HfLYenjKx5hFLW+50=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 06/21] staging: ft1000: Fix identation in ftnet_ops struct.
Date: Thu, 10 Mar 2011 11:51:20 +0100
Message-Id: <1299754295-8493-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
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

