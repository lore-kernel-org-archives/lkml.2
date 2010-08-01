Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0HAOvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 10:51:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259Ab0HAOvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 10:51:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Martin Steigerwald" <ms@teamix.de>, "Neil Brown" <neilb@suse.de>
References: <JKn8_uSlpqD.A.HLG.1LYVMB@chimera>
In-Reply-To: <JKn8_uSlpqD.A.HLG.1LYVMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <FMobw2FohV.A.OOG.9LYVMB@chimera>
Subject: [Bug #16431] does not seem to shut down one of two md raid-1 arrays on hibernation
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  1 Aug 2010 16:44:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16431
Subject		: does not seem to shut down one of two md raid-1 arrays on hibernation
Submitter	: Martin Steigerwald <ms@teamix.de>
Date		: 2010-07-21 13:08 (12 days old)
Handled-By	: Neil Brown <neilb@suse.de>


