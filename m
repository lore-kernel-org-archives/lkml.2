Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab1ENWwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:52:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab1ENWtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:49:46 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Johannes Berg" <johannes@sipsolutions.net>
References: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera>
In-Reply-To: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SFkDk2sBn_E.A.nqD.RRwzNB@chimera>
Subject: [Bug #31782] nouveau: lockdep spew
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 15 May 2011 00:40:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31782
Subject		: nouveau: lockdep spew
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2011-03-24 09:51 (52 days old)


