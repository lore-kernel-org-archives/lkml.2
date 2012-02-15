Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2BOTUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:20:22 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60121 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017Ab2BOTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:20:19 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] char/ramoops: included linux/err.h twice
Date: Wed, 15 Feb 2012 20:20:16 +0100
Message-Id: <1329333616-31938-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333619;8a8fa506;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/ramoops.c included 'linux/err.h' twice, remove
the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/char/ramoops.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 9fec323..2a5e45d2 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/kmsg_dump.h>
 #include <linux/time.h>
-#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
-- 
1.7.8.3

