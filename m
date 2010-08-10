Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0HJV7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:59:36 -0400
Received: from kroah.org ([198.145.64.141]:44772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933224Ab0HJV7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:59:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/68] n_gsm.c: removed duplicated #includes
Date: Tue, 10 Aug 2010 14:58:23 -0700
Message-Id: <1281477570-18944-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
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

