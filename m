Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0H2X3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:29:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0H2X3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:29:13 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
In-Reply-To: <c1_O4wHrlB.A.63.mbueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ByD_7B96czP.A.XtC.eeueMB@chimera>
Subject: [Bug #16399] perf failed with kernel 2.6.35-rc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 01:13:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16399
Subject		: perf failed with kernel 2.6.35-rc
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2010-07-13 8:14 (48 days old)
First-Bad-Commit: http://git.kernel.org/linus/1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
Message-ID	: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=127900880212470&w=2


