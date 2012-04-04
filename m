Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2DDI0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:26:00 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:61942 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2DDIZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:25:57 -0400
Date: Wed, 4 Apr 2012 10:25:52 +0200
From: Alessandro Rubini <rubini@cvml.unipv.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] misc: remove me from maintainers file
Message-ID: <20120404082552.GA1450@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm definitely not up to date on the subject matter any more
and haven't been able to comment on the messages on the topic.

Signed-off-by: Alessandro Rubini <rubini@ipvvis.unipv.it>
---

(Cc:ing andrew as it looks like maintainer entries go through him)

 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05f9c4e..5ea84cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4462,12 +4462,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
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
1.7.7.2
