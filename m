Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0D3Qxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:53:55 -0400
Received: from kroah.org ([198.145.64.141]:53028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577Ab0D3Qxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:53:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ping Cheng <pingc@wacom.com>, stable <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] serial: 8250_pnp - add Fujitsu Wacom device
Date: Fri, 30 Apr 2010 09:37:39 -0700
Message-Id: <1272645460-16491-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100430163654.GB16424@kroah.com>
References: <20100430163654.GB16424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ping Cheng <pingc@wacom.com>

Add Fujitsu Wacom 1FGT Tablet PC device

Signed-off-by: Ping Cheng <pingc@wacom.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250_pnp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index 24485cc..4822cb5 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -348,6 +348,8 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{	"FUJ02E6",		0	},
 	/* Fujitsu Wacom 2FGT Tablet PC device */
 	{	"FUJ02E7",		0	},
+	/* Fujitsu Wacom 1FGT Tablet PC device */
+	{	"FUJ02E9",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
 	 * disguise)
-- 
1.7.0.4

