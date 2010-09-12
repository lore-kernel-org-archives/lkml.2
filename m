Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0ILSeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:34:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab0ILSeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:34:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Maxime Bizon" <mbizon@freebox.fr>,
        "Miles Lane" <miles.lane@gmail.com>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
In-Reply-To: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <0c5PAlgnPrH.A.LyB.KsRjMB@chimera>
Subject: [Bug #17311] 2.6.36-rc2-git4 - INFO: possible circular locking dependency detected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 20:14:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17311
Subject		: 2.6.36-rc2-git4 - INFO: possible circular locking dependency detected
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-08-27 1:56 (17 days old)
First-Bad-Commit: http://git.kernel.org/linus/5a652052fedbd7869572c757dd2ffc2ed420c69d
Message-ID	: <AANLkTinHbEW36D5R9NSrGgfbOC0Hri3Tg-fA0iR92Udi@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=128287422106267&w=2
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


