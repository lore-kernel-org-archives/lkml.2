Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1GJLF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:05:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab1GJLFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:05:50 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "RKK" <kulkarni.ravi4@gmail.com>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
In-Reply-To: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XNkIyhV6dgF.A._cG.6BYGOB@chimera>
Subject: [Bug #38732] Linux 3.0-rc5 doesnt boot and hangs at rcu_sched_state ()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jul 2011 12:38:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38732
Subject		: Linux 3.0-rc5 doesnt boot and hangs at rcu_sched_state ()
Submitter	: RKK <kulkarni.ravi4@gmail.com>
Date		: 2011-06-29 13:38 (12 days old)
Message-ID	: <BANLkTikW6Xk8UMsOHLCnLn7STRzy8RaiJA@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=130935402722869&w=2


