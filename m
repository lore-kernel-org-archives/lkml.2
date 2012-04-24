Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2DXGcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:32:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48707 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2DXGcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:32:53 -0400
Date: Mon, 23 Apr 2012 23:32:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Alessandro Rubini <rubini@gnudd.com>, linux-input@vger.kernel.org
Subject: [PATCH] MAINTAINERS - remove Alessandro Rubini from mice maintainers
Message-ID: <20120424063246.GA32680@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not recall Alessandro replying to mice-related question or patches
for ages so let's stop people using get-maintainer.pl from CCing him
with patches.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7f7a96..114ffd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4465,12 +4465,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/mmc/host/imxmmc.*
 
-MOUSE AND MISC DEVICES [GENERAL]
-M:	Alessandro Rubini <rubini@ipvvis.unipv.it>
-S:	Maintained
-F:	drivers/input/mouse/
-F:	include/linux/gpio_mouse.h
-
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
-- 
1.7.7.6


-- 
Dmitry
