Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab1ENWuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:50:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759632Ab1ENWuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:50:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Luke-Jr" <luke-jr+linuxbugs@utopios.org>
References: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera>
In-Reply-To: <Zsp7lN2vZ2O.A.J7C.bQwzNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SFkDk2sBn_E.A.ARD.zQwzNB@chimera>
Subject: [Bug #33662] System hangs during X startup (kwin compositing?)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 15 May 2011 00:40:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33662
Subject		: System hangs during X startup (kwin compositing?)
Submitter	: Luke-Jr <luke-jr+linuxbugs@utopios.org>
Date		: 2011-04-19 04:26 (26 days old)
First-Bad-Commit: http://git.kernel.org/linus/e8616b6ced6137085e6657cc63bc2fe3900b8616


