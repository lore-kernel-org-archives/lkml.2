Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1HMTfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:35:52 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:48876 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752481Ab1HMTfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:35:23 -0400
Date: Sat, 13 Aug 2011 12:34:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH 7/8] Documentation: SubmittingDrivers: fix Linus's git tree
 URL
Message-Id: <20110813123457.1f2274cc.rdunlap@xenotime.net>
In-Reply-To: <20110813122200.8e2fc879.rdunlap@xenotime.net>
References: <20110813122200.8e2fc879.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Thielow <ralf.thielow@googlemail.com>

Change resource URL to new git tree -
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git).

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/SubmittingDrivers |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-31-rc1-git7.orig/Documentation/SubmittingDrivers
+++ lnx-31-rc1-git7/Documentation/SubmittingDrivers
@@ -130,7 +130,7 @@ Linux kernel master tree:
 	ftp.??.kernel.org:/pub/linux/kernel/...
 	?? == your country code, such as "us", "uk", "fr", etc.
 
-	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
+	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git
 
 Linux kernel mailing list:
 	linux-kernel@vger.kernel.org
