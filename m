Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1COXLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:11:32 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:52704 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751858Ab1COXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:11:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ts9bD6qHGiPirfjJ6gt3JfZLLsbZua1FygLJF+F2RW7D8uksphHipcwzFzXj3jqD+s4vPgFLIfAYC3w/XtragRr0uJGOslQuSI9uIqk0mNfhlrcOiAFiB5UbJvvE6Tiu;
Date: Tue, 15 Mar 2011 16:11:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Rob Landley <rlandley@parallels.com>
Subject: [PATCH 1/6] Documentation: remove obsolete files from 00-INDEX
Message-Id: <20110315161129.d7344a6d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

Time interpolators were removed in git 1f564ad6d41828
Voyager support went away in git b6b6e2b112caf

Signed-off-by: Rob Landley <rlandley@parallels.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 Documentation/00-INDEX |    4 ----
 1 file changed, 4 deletions(-)

--- lnx-2638-rc8.orig/Documentation/00-INDEX
+++ lnx-2638-rc8/Documentation/00-INDEX
@@ -328,8 +328,6 @@ sysrq.txt
 	- info on the magic SysRq key.
 telephony/
 	- directory with info on telephony (e.g. voice over IP) support.
-time_interpolators.txt
-	- info on time interpolators.
 uml/
 	- directory with information about User Mode Linux.
 unicode.txt
@@ -346,8 +344,6 @@ vm/
 	- directory with info on the Linux vm code.
 volatile-considered-harmful.txt
 	- Why the "volatile" type class should not be used
-voyager.txt
-	- guide to running Linux on the Voyager architecture.
 w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
