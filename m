Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1DDWNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:13:02 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:51760 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752484Ab1DDWMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RQRPcxkWhl1gM0ApfqrPCBAu9RbQOOpEqeULHomqXJEvWHd0lrKPT/0eGVn/HSUjb+ASetI6+yWt91/YNgE+Ba58HWB08vlezqjCrIZQ3IYtFxjM3ir6kCYHYOUftMbG;
Date: Mon, 4 Apr 2011 15:10:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Geunsik Lim <geunsik.lim@samsung.com>, Paul Menage <menage@google.com>
Subject: [PATCH 8/8] Documentation: update cgroups info user groups names
Message-Id: <20110404151045.89e63510.rdunlap@xenotime.net>
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

From: Geunsik Lim <geunsik.lim@samsung.com>

Update suitable words to explain / understand cgroups contents.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/cgroups/cgroups.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.38-git18.orig/Documentation/cgroups/cgroups.txt
+++ linux-2.6.38-git18/Documentation/cgroups/cgroups.txt
@@ -110,22 +110,22 @@ university server with various users - s
 tasks etc. The resource planning for this server could be along the
 following lines:
 
-       CPU :           Top cpuset
+       CPU :          "Top cpuset"
                        /       \
                CPUSet1         CPUSet2
-                  |              |
-               (Profs)         (Students)
+                  |               |
+               (Professors)    (Students)
 
                In addition (system tasks) are attached to topcpuset (so
                that they can run anywhere) with a limit of 20%
 
-       Memory : Professors (50%), students (30%), system (20%)
+       Memory : Professors (50%), Students (30%), system (20%)
 
-       Disk : Prof (50%), students (30%), system (20%)
+       Disk : Professors (50%), Students (30%), system (20%)
 
        Network : WWW browsing (20%), Network File System (60%), others (20%)
                                / \
-                       Prof (15%) students (5%)
+               Professors (15%)  students (5%)
 
 Browsers like Firefox/Lynx go into the WWW network class, while (k)nfsd go
 into NFS network class.
