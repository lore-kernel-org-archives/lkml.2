Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0HEWXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:23:41 -0400
Received: from kroah.org ([198.145.64.141]:37540 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab0HEWXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/67] n_gsm.c: removed duplicated #includes
Date: Thu,  5 Aug 2010 15:22:28 -0700
Message-Id: <1281047014-23429-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>

drivers/char/n_gsm.c: linux/timer.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/n_gsm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/n_gsm.c b/drivers/char/n_gsm.c
index e4089c4..099105e 100644
--- a/drivers/char/n_gsm.c
+++ b/drivers/char/n_gsm.c
@@ -43,7 +43,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
-#include <linux/timer.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-- 
1.7.2

