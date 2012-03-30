Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480Ab2C3UhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:37:22 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56025 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761449Ab2C3UhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:37:16 -0400
Message-ID: <4F761979.9030009@xenotime.net>
Date: Fri, 30 Mar 2012 13:37:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, jidanni@jidanni.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5/8] Documentation: input.txt: clarify mousedev 'cat' command
 syntax
References: <4F761580.3020807@xenotime.net>
In-Reply-To: <4F761580.3020807@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Clarify that the 'cat' command does not include the (c, 13, 32)
after it.

Reported-by: jidanni@jidanni.org
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/input/input.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-33.orig/Documentation/input/input.txt
+++ lnx-33/Documentation/input/input.txt
@@ -250,8 +250,8 @@ And so on up to event31.
 a USB keyboard works and is correctly connected to the kernel keyboard
 driver. 
 
-  Doing a cat /dev/input/mouse0 (c, 13, 32) will verify that a mouse
-is also emulated, characters should appear if you move it.
+  Doing a "cat /dev/input/mouse0" (c, 13, 32) will verify that a mouse
+is also emulated; characters should appear if you move it.
 
   You can test the joystick emulation with the 'jstest' utility,
 available in the joystick package (see Documentation/input/joystick.txt).
