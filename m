Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1HNTsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:48:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab1HNTrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:47:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Stephan Seitz" <stse+lkml@fsing.rootsland.net>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
In-Reply-To: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bkwpSnItbJM.A.r-H.mMCSOB@chimera>
Subject: [Bug #40282] IP forwarding regression since 3.0-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 14 Aug 2011 21:07:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.39 and 3.0.

The following bug entry is on the current list of known regressions
introduced between 2.6.39 and 3.0.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=40282
Subject		: IP forwarding regression since 3.0-rc6
Submitter	: Stephan Seitz <stse+lkml@fsing.rootsland.net>
Date		: 2011-07-25 12:51 (21 days old)
Message-ID	: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
References	: http://marc.info/?l=linux-kernel&m=131159880004908&w=2


