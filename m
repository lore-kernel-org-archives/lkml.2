Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0LEUfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:35:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0LEUfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:35:50 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dominik Brodowski" <linux@dominikbrodowski.net>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Justin Mattock" <justinmattock@gmail.com>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
In-Reply-To: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <z3LGq_ncuOB.A.huF.kB_-MB@chimera>
Subject: [Bug #19392] WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  5 Dec 2010 21:34:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19392
Subject		: WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2010-09-28 22:30 (69 days old)
Message-ID	: <<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>>
References	: http://marc.info/?l=linux-kernel&m=128571307018635&w=2


