Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1CFMwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:52:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab1CFMwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:52:38 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Gu Rui" <chaos.proton@gmail.com>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>
References: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
In-Reply-To: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sUKqYsqyJ4N.A.SQG.U_3cNB@chimera>
Subject: [Bug #28582] whole system hang when start X
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Mar 2011 13:40:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.36 and 2.6.37.

The following bug entry is on the current list of known regressions
introduced between 2.6.36 and 2.6.37.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28582
Subject		: whole system hang when start X
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2011-02-08 08:33 (27 days old)
First-Bad-Commit: http://git.kernel.org/linus/d5bb081b027b520f9e59b4fb8faea83a136ec15e


