Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1HNTqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:46:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab1HNTqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:46:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Vegard Nossum" <vegard.nossum@gmail.com>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
In-Reply-To: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bkwpSnItbJM.A.xi.BNCSOB@chimera>
Subject: [Bug #39912] WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 14 Aug 2011 21:07:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39912
Subject		: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2011-07-19 11:33 (27 days old)
Message-ID	: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=131107522914558&w=2


