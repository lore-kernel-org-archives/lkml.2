Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0ITUT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:19:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab0ITUT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:19:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Dave Airlie" <airlied@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
In-Reply-To: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <aRnAGz9xZ8K.A.NtG.KB8lMB@chimera>
Subject: [Bug #16265] Why is kslowd accumulating so much CPU time?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 20 Sep 2010 21:57:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16265
Subject		: Why is kslowd accumulating so much CPU time?
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2010-06-09 18:36 (104 days old)
First-Bad-Commit: http://git.kernel.org/linus/fbf81762e385d3d45acad057b654d56972acf58c
Message-ID	: <E1OMQ88-0002a1-Gb@closure.thunk.org>
References	: http://marc.info/?l=linux-kernel&m=127610857819033&w=4
		  http://bugs.freedesktop.org/show_bug.cgi?id=29536
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


