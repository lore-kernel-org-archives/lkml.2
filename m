Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1AFAam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47357 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1AFAah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:37 -0500
Date: Wed, 5 Jan 2011 16:27:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/3] Documentation: update kernel-docs.txt
Message-Id: <20110105162753.d29c814c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Kaiser <nikai@nikai.net>

Fixed typos, and removed duplicated entries.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-docs.txt |   27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

--- lnx-2637-rc4.orig/Documentation/kernel-docs.txt
+++ lnx-2637-rc4/Documentation/kernel-docs.txt
@@ -537,7 +537,7 @@
        Notes: Further information in
        http://www.oreilly.com/catalog/linuxdrive2/
 
-     * Title: "Linux Device Drivers, 3nd Edition"
+     * Title: "Linux Device Drivers, 3rd Edition"
        Authors: Jonathan Corbet, Alessandro Rubini, and Greg Kroah-Hartman
        Publisher: O'Reilly & Associates.
        Date: 2005.
@@ -592,14 +592,6 @@
        Pages: 600.
        ISBN: 0-13-101908-2
 
-     * Title:  "The  Design  and Implementation of the 4.4 BSD UNIX
-       Operating System"
-       Author: Marshall Kirk McKusick, Keith Bostic, Michael J. Karels,
-       John S. Quarterman.
-       Publisher: Addison-Wesley.
-       Date: 1996.
-       ISBN: 0-201-54979-4
-
      * Title: "Programming for the real world - POSIX.4"
        Author: Bill O. Gallmeister.
        Publisher: O'Reilly & Associates, Inc..
@@ -610,28 +602,13 @@
        POSIX. Good reference.
 
      * Title:  "UNIX  Systems  for  Modern Architectures: Symmetric
-       Multiprocesssing and Caching for Kernel Programmers"
+       Multiprocessing and Caching for Kernel Programmers"
        Author: Curt Schimmel.
        Publisher: Addison Wesley.
        Date: June, 1994.
        Pages: 432.
        ISBN: 0-201-63338-8
 
-     * Title:  "The  Design  and Implementation of the 4.3 BSD UNIX
-       Operating System"
-       Author: Samuel J. Leffler, Marshall Kirk McKusick, Michael J.
-       Karels, John S. Quarterman.
-       Publisher: Addison-Wesley.
-       Date: 1989 (reprinted with corrections on October, 1990).
-       ISBN: 0-201-06196-1
-
-     * Title: "The Design of the UNIX Operating System"
-       Author: Maurice J. Bach.
-       Publisher: Prentice Hall.
-       Date: 1986.
-       Pages: 471.
-       ISBN: 0-13-201757-1
-
      MISCELLANEOUS:
 
      * Name: linux/Documentation
