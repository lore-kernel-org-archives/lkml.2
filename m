Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1BJURR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:17:17 -0500
Received: from kroah.org ([198.145.64.141]:42877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab1BJURP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:17:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>,
        stable@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] n_gsm: copy mtu over when configuring via ioctl interface
Date: Thu, 10 Feb 2011 12:17:10 -0800
Message-Id: <1297369032-18502-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110210201520.GA18283@kroah.com>
References: <20110210201520.GA18283@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Mills <ken.k.mills@intel.com>

This field is settable but did not get copied.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/n_gsm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 44b8412..aa2e5d3 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2414,6 +2414,7 @@ static int gsmld_config(struct tty_struct *tty, struct gsm_mux *gsm,
 
 	gsm->initiator = c->initiator;
 	gsm->mru = c->mru;
+	gsm->mtu = c->mtu;
 	gsm->encoding = c->encapsulation;
 	gsm->adaption = c->adaption;
 	gsm->n2 = c->n2;
-- 
1.7.3.2

