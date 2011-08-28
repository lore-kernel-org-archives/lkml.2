Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1H1Tpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:45:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1H1To6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:44:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Tino Keitel" <tino.keitel@tikei.de>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
In-Reply-To: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gUVi6eNP8RE.A.rqG.2epWOB@chimera>
Subject: [Bug #40062] USB related "unable to handle kernel paging request" in 3.0.0-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 28 Aug 2011 21:01:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40062
Subject		: USB related "unable to handle kernel paging request" in 3.0.0-rc7
Submitter	: Tino Keitel <tino.keitel@tikei.de>
Date		: 2011-07-22 19:27 (38 days old)
Message-ID	: <20110722192722.GA9369@x61.home>
References	: http://marc.info/?l=linux-kernel&m=131136334621623&w=2
Patch		: https://lkml.org/lkml/2011/8/2/174


