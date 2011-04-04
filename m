Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1DDWNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:13:50 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:59047 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755672Ab1DDWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gtE260Uhhb13CgRojxm3/RCXvKVAZppCw8/q0raPrW1nqg9OzWHPRDJ/nssXkgEJ/IHND2QT+iGze50Rn2DbLznVP/sV4HTmjOqehISx4bU8w4Ly+bL6o8OVvXNum0D/;
Date: Mon, 4 Apr 2011 15:02:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH 4/8] Documentation: update panic parameter info
Message-Id: <20110404150224.98c6f633.rdunlap@xenotime.net>
In-Reply-To: <20110404145803.8663081d.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add a little more info for some of the panic-related kernel parameters.
Fix "oops=panic" to fit in 80 columns.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
---
 Documentation/kernel-parameters.txt |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux-2.6.38-git18.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.38-git18/Documentation/kernel-parameters.txt
@@ -1832,15 +1832,17 @@ bytes respectively. Such letter suffixes
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
-	oops=panic	Always panic on oopses. Default is to just kill the process,
-			but there is a small probability of deadlocking the machine.
+	oops=panic	Always panic on oopses. Default is to just kill the
+			process, but there is a small probability of
+			deadlocking the machine.
 			This will also cause panics on machine check exceptions.
 			Useful together with panic=30 to trigger a reboot.
 
 	OSS		[HW,OSS]
 			See Documentation/sound/oss/oss-parameters.txt
 
-	panic=		[KNL] Kernel behaviour on panic
+	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
+			seconds before rebooting
 			Format: <timeout>
 
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
@@ -2343,6 +2345,7 @@ bytes respectively. Such letter suffixes
 
 	softlockup_panic=
 			[KNL] Should the soft-lockup detector generate panics.
+			Format: <integer>
 
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/sonypi.txt
@@ -2529,8 +2532,7 @@ bytes respectively. Such letter suffixes
 			reported either.
 
 	unknown_nmi_panic
-			[X86]
-			Set unknown_nmi_panic=1 early on boot.
+			[X86] Cause panic on unknown NMI.
 
 	usbcore.autosuspend=
 			[USB] The autosuspend time delay (in seconds) used
