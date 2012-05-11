Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946055Ab2EKTbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:31:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422660Ab2EKTay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:30:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: Add myself as the cpufreq maintainer
Date: Fri, 11 May 2012 21:35:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org
References: <20120504160417.GA421@redhat.com> <201205112116.25257.rjw@sisk.pl> <20120511192420.GA10041@redhat.com>
In-Reply-To: <20120511192420.GA10041@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205112135.46097.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since cpufreq has no official maintainer at the moment, I'm willing
to maintain it along some other power management core code I've been
maintaining already.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -1970,7 +1970,9 @@ S:	Maintained
 F:	drivers/net/ethernet/ti/cpmac.c
 
 CPU FREQUENCY DRIVERS
+M:	Rafael J. Wysocki <rjw@sisk.pl>
 L:	cpufreq@vger.kernel.org
+L:	linux-pm@vger.kernel.org
 S:	Maintained
 F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h

