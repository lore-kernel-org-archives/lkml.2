Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2BFRt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:49:58 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42369 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753869Ab2BFRtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:49:55 -0500
Message-ID: <4F3012BE.5080305@xenotime.net>
Date: Mon, 06 Feb 2012 09:49:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/2] Documentation: add missing tainted bits to Documentation/sysctl/kernel.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

Two of the bits in the tainted flag are not documented.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---

---
 Documentation/sysctl/kernel.txt |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-33-rc2.orig/Documentation/sysctl/kernel.txt
+++ lnx-33-rc2/Documentation/sysctl/kernel.txt
@@ -601,6 +601,8 @@ can be ORed together:
         instead of using the one provided by the hardware.
  512 - A kernel warning has occurred.
 1024 - A module from drivers/staging was loaded.
+2048 - The system is working around a severe firmware bug.
+4096 - An out-of-tree module has been loaded.
 
 ==============================================================
 
