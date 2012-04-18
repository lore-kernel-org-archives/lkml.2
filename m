Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2DREee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:34:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35957 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2DREeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:34:31 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: [PATCH 10/12] drivers: staging: media: easycap: easycap_ioctl: Include version.h header
Date: Wed, 18 Apr 2012 01:30:10 -0300
Message-Id: <1334723412-5034-11-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" told us that:

drivers/staging/media/easycap/easycap_ioctl.c: 2442: need
linux/version.h

If we take a look at the code, we will see the macro KERNEL_VERSION be
used. So, we need this include.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-media@vger.kernel.org>
Cc: <devel@driverdev.osuosl.org >
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/media/easycap/easycap_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_ioctl.c b/drivers/staging/media/easycap/easycap_ioctl.c
index 9413b37..3cee3cd 100644
--- a/drivers/staging/media/easycap/easycap_ioctl.c
+++ b/drivers/staging/media/easycap/easycap_ioctl.c
@@ -26,6 +26,7 @@
 /*****************************************************************************/
 
 #include "easycap.h"
+#include <linux/version.h>
 
 /*--------------------------------------------------------------------------*/
 /*
-- 
1.7.7.6

