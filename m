Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0FEVFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:05:19 -0400
Received: from a.ns.miles-group.at ([217.188.240.210]:48133 "EHLO
	radon.swed.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab0FEVFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:05:17 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, alan@linux.intel.com, akpm@linux-foundation.org,
       joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] char: Remove unused variable
Date: Sat,  5 Jun 2010 22:58:10 +0200
Message-Id: <1275771490-15190-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

card is never used within isicom_open().

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/char/isicom.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 98310e1..50e4265 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -872,7 +872,6 @@ static struct tty_port *isicom_find_port(struct tty_struct *tty)
 static int isicom_open(struct tty_struct *tty, struct file *filp)
 {
 	struct isi_port *port;
-	struct isi_board *card;
 	struct tty_port *tport;
 
 	tport = isicom_find_port(tty);
-- 
1.6.6.1

