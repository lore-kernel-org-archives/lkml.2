Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab1EZAHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:07:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604Ab1EZAHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:07:00 -0400
Date: Wed, 25 May 2011 20:06:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Anatolij Gustschin <agust@denx.de>
Subject: fix missing udelay include in mb862xx-i2c
Message-ID: <20110526000655.GB21913@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Anatolij Gustschin <agust@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/mb862xx/mb862xx-i2c.c: In function ‘mb862xx_i2c_wait_event’:
drivers/video/mb862xx/mb862xx-i2c.c:25:3: error: implicit declaration of function ‘udelay’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/video/mb862xx/mb862xx-i2c.c b/drivers/video/mb862xx/mb862xx-i2c.c
index cb77d3b..87c79ee 100644
--- a/drivers/video/mb862xx/mb862xx-i2c.c
+++ b/drivers/video/mb862xx/mb862xx-i2c.c
@@ -12,6 +12,7 @@
 #include <linux/fb.h>
 #include <linux/i2c.h>
 #include <linux/io.h>
+#include <asm/delay.h>
 
 #include "mb862xxfb.h"
 #include "mb862xx_reg.h"
