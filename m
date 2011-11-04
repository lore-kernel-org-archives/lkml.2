Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab1KDSXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:23:16 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38667 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933185Ab1KDSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:23:12 -0400
Message-ID: <4EB42D62.4040603@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcos Paulo Souza <marcos.mage@gmail.com>
Subject: [PATCH 6/8] Documentation: Computone ip2 is orphaned
References: <4EB423D8.9030102@xenotime.net>
In-Reply-To: <4EB423D8.9030102@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcos Paulo Souza <marcos.mage@gmail.com>

Removed the email for support and fixes for orphaned ip2 driver.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/serial/computone.txt |    2 --
 1 file changed, 2 deletions(-)

--- lnx1104.orig/Documentation/serial/computone.txt
+++ lnx1104/Documentation/serial/computone.txt
@@ -20,8 +20,6 @@ Version: 1.2.14
 Date: 11/01/2001
 Historical Author: Andrew Manison <amanison@america.net>
 Primary Author: Doug McNash
-Support: support@computone.com
-Fixes and Updates: Mike Warfield <mhw@wittsend.com>
 
 This file assumes that you are using the Computone drivers which are
 integrated into the kernel sources.  For updating the drivers or installing
