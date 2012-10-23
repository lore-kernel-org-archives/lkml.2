Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab2JWUwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:52:08 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42274 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933767Ab2JWUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Henk de Groot <pe1dnn@amsat.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 124/193] drivers/staging/wlags49_h2/man: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:17 -0700
Message-Id: <1351022666-6960-125-git-send-email-keescook@chromium.org>
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

CC: Henk de Groot <pe1dnn@amsat.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/wlags49_h2/man/wlags49.4 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/man/wlags49.4 b/drivers/staging/wlags49_h2/man/wlags49.4
index a345885..37df998 100644
--- a/drivers/staging/wlags49_h2/man/wlags49.4
+++ b/drivers/staging/wlags49_h2/man/wlags49.4
@@ -108,7 +108,7 @@ with the I/O base address and MAC address used by the card.
  \- Card power management
  \- Support for Hermes-II & Hermes-II.5 based PCMCIA, Mini PCI, and CardBus cards
  \- Wired Equivalent Privacy (WEP)
- \- WPA-PSK support (EXPERIMENTAL)
+ \- WPA-PSK support
  \- Driver utility interface (UIL)
  \- Wireless Extensions
  \- Software AP mode
-- 
1.7.9.5

