Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965245Ab2JWUua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:50:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36231 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933772Ab2JWUFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:22 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH 053/193] drivers/iio/dac: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:06 -0700
Message-Id: <1351022666-6960-54-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Jonathan Cameron <jic23@cam.ac.uk>
CC: Lars-Peter Clausen <lars@metafoo.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Michael Hennerich <michael.hennerich@analog.com>
CC: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/iio/dac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/Kconfig b/drivers/iio/dac/Kconfig
index b1c0ee5..1f3ce77 100644
--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -122,7 +122,7 @@ config AD5686
 
 config MAX517
 	tristate "Maxim MAX517/518/519 DAC driver"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C
 	help
 	  If you say yes here you get support for the Maxim chips MAX517,
 	  MAX518 and MAX519 (I2C 8-Bit DACs with rail-to-rail outputs).
-- 
1.7.9.5

