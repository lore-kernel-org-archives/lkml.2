Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0IUXCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:02:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44550 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0IUXCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:02:22 -0400
Date: Tue, 21 Sep 2010 16:01:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        David Airlie <airlied@linux.ie>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: [PATCH] documentation: update sysrq.txt key mappings
Message-Id: <20100921160142.7c783105.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update Documentation/sysrq.txt magic sysrq keys:

- 'g' is for kgdb (not arch-specific);
- add 2 new uses for 'v', remove the Voyager info;
- add 'y' info (SPARC-64 specific);

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jason Wessel <jason.wessel@windriver.com>
Cc:	"David S. Miller" <davem@davemloft.net>
Cc:	"James E.J. Bottomley" <James.Bottomley@suse.de>
Cc:	David Airlie <airlied@linux.ie>
Cc:	Alexander Shishkin <virtuoso@slind.org>
---
 Documentation/sysrq.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- lnx-2636-rc5.orig/Documentation/sysrq.txt
+++ lnx-2636-rc5/Documentation/sysrq.txt
@@ -75,7 +75,7 @@ On all -  write a character to /proc/sys
 
 'f'	- Will call oom_kill to kill a memory hog process.
 
-'g'	- Used by kgdb on ppc and sh platforms.
+'g'	- Used by kgdb (kernel debugger)
 
 'h'     - Will display help (actually any other key than those listed
           here will display help. but 'h' is easy to remember :-)
@@ -110,12 +110,15 @@ On all -  write a character to /proc/sys
 
 'u'     - Will attempt to remount all mounted filesystems read-only.
 
-'v'	- Dumps Voyager SMP processor info to your console.
+'v'	- Forcefully restores framebuffer console
+'v'	- Causes ETM buffer dump [ARM-specific]
 
 'w'	- Dumps tasks that are in uninterruptable (blocked) state.
 
 'x'	- Used by xmon interface on ppc/powerpc platforms.
 
+'y'	- Show global CPU Registers [SPARC-64 specific]
+
 'z'	- Dump the ftrace buffer
 
 '0'-'9' - Sets the console log level, controlling which kernel messages
