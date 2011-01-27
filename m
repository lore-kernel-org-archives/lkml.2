Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1A0Tju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:39:50 -0500
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:57968 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752681Ab1A0Tjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:39:45 -0500
Subject: [PATCH 2/2] USB: tools: Add a Makefile
From: Davidlohr Bueso <dave@gnu.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 16:39:34 -0300
Message-ID: <1296157174.2113.6.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I originally sent this in several months ago, but never got around to correcting the changes, so... here it is.

From: Davidlohr Bueso <dave@gnu.org>

Build USB tools easier.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 tools/usb/Makefile |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 tools/usb/Makefile

diff --git a/tools/usb/Makefile b/tools/usb/Makefile
new file mode 100644
index 0000000..3995509
--- /dev/null
+++ b/tools/usb/Makefile
@@ -0,0 +1,13 @@
+# Makefile for building 'usbtest'
+
+CC = $(CROSS_COMPILE)gcc
+PTHREAD_LIBS = -lpthread
+WARNINGS = -Wall -Wextra
+CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
+
+all: testusb ffs-test
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^
+
+clean:
+	$(RM) testusb ffs-test
-- 
1.7.1




