Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423Ab2C3UhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:37:08 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:47917 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760698Ab2C3UhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:37:05 -0400
Message-ID: <4F76196E.6010707@xenotime.net>
Date: Fri, 30 Mar 2012 13:37:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Javi Merino <javi.merino@arm.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 2/8] Documentation: mention scripts/diffconfig tool
References: <4F761580.3020807@xenotime.net>
In-Reply-To: <4F761580.3020807@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	"Javi Merino" <javi.merino@arm.com>

Documentation: Mention scripts/diffconfig as a tool to compare config files

The kconfig documentation suggests using plain 'diff' to compare
config files and then adds "Yes, we need something better here".
"a717417 kconfig: add diffconfig utility" added what that comment was
looking for.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Cc: Michal Marek <mmarek@suse.cz>
---
 Documentation/kbuild/kconfig.txt |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- lnx-33.orig/Documentation/kbuild/kconfig.txt
+++ lnx-33/Documentation/kbuild/kconfig.txt
@@ -28,12 +28,10 @@ new (default) values, so you can use:
 
 	grep "(NEW)" conf.new
 
-to see the new config symbols or you can 'diff' the previous and
-new .config files to see the differences:
+to see the new config symbols or you can use diffconfig to see the
+differences between the previous and new .config files:
 
-	diff .config.old .config | less
-
-(Yes, we need something better here.)
+	scripts/diffconfig .config.old .config | less
 
 ______________________________________________________________________
 Environment variables for '*config'
