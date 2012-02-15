Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2BORzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:55:47 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41696 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043Ab2BORzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:55:44 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty/serial/mux.c: linux/tty.h included twice
Date: Wed, 15 Feb 2012 18:55:41 +0100
Message-Id: <1329328541-4902-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329328544;d84496ca;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/mux.c included 'linux/tty.h' twice, remove
the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/tty/serial/mux.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/mux.c b/drivers/tty/serial/mux.c
index 06f6aef..d080bc5 100644
--- a/drivers/tty/serial/mux.c
+++ b/drivers/tty/serial/mux.c
@@ -17,7 +17,6 @@
 */
 
 #include <linux/module.h>
-#include <linux/tty.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/serial.h>
-- 
1.7.8.3

