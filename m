Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2DREeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:34:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35957 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2DREd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:33:58 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>
Subject: [PATCH 04/12] drivers: media: radio: radio-keene.c: Remove unneeded include of version.h
Date: Wed, 18 Apr 2012 01:30:04 -0300
Message-Id: <1334723412-5034-5-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" told us that:

drivers/media/radio/radio-keene.c: 31 linux/version.h not needed.

After take a look in the code, we can agree to remove it.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/media/radio/radio-keene.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 55bd1d2..26a2b7a 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -28,7 +28,6 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <linux/usb.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 
 /* driver and module definitions */
-- 
1.7.7.6

