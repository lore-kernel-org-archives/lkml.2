Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab0KLVlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:32 -0500
Received: from kroah.org ([198.145.64.141]:41595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab0KLVlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/19] n_gsm: Copy n2 over when configuring via ioctl interface
Date: Fri, 12 Nov 2010 13:41:05 -0800
Message-Id: <1289598066-10112-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Mills <ken.k.mills@intel.com>

The n2 field is settable but didn't get propogated

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/n_gsm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 04ef3ef..7f79044 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2375,6 +2375,7 @@ static int gsmld_config(struct tty_struct *tty, struct gsm_mux *gsm,
 	gsm->mru = c->mru;
 	gsm->encoding = c->encapsulation;
 	gsm->adaption = c->adaption;
+	gsm->n2 = c->n2;
 
 	if (c->i == 1)
 		gsm->ftype = UIH;
-- 
1.7.1

