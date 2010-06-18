Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab0FRRnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:43:45 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45923 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0FRRno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:43:44 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "paul.larson" <paul.larson@ubuntu.com>,
       Garrett Cooper <yanegomi@gmail.com>, Nathan Straz <nstraz@redhat.com>,
       Mike Frysinger <vapier@gentoo.org>,
       Robbie Williamson <robbie@ubuntu.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       "manoj.iyer" <manoj.iyer@canonical.com>,
       ltp-list <ltp-list@lists.sf.net>, Sudarshan Rao <rsudarsh@in.ibm.com>,
       Michael Reed <mreed10@us.ibm.com>
Date: Fri, 18 Jun 2010 23:13:31 +0530
Message-Id: <20100618174331.5435.11325.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH] Updated Information about Linux Test Project Maintainence
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6/MAINTAINERS.orig	2010-06-18 23:08:30.000000000 +0530
+++ linux-2.6/MAINTAINERS	2010-06-18 23:09:41.000000000 +0530
@@ -3413,9 +3413,10 @@ F:	drivers/scsi/sym53c8xx_2/
 LTP (Linux Test Project)
 M:	Subrata Modak <subrata@linux.vnet.ibm.com>
 M:	Mike Frysinger <vapier@gentoo.org>
+M:	Garrett Cooper <yanegomi@gmail.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
+T:	git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:	Maintained
 
 M32R ARCHITECTURE
