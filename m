Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0LARv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:51:27 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:45467 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab0LARv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:51:26 -0500
Date: Wed, 1 Dec 2010 18:48:21 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: kernel-docs: fix typos, remove duplicated
 entries
Message-ID: <20101201184821.6be9560d@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed typos, and removed duplicated entries.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 Documentation/kernel-docs.txt |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
index 715eaaf..9a86746 100644
--- a/Documentation/kernel-docs.txt
+++ b/Documentation/kernel-docs.txt
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
-- 
1.7.2.2
