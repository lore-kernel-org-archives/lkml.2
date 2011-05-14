Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab1ENWk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:40:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51806 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab1ENWiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:38:52 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
In-Reply-To: <So1vU2GC7XM.A.5wB.44vzNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <HA8urZ3ZRcP.A.6QC.Q5vzNB@chimera>
Subject: [Bug #34492] [2.6.39-rc4, x86_32] Stall at default_idle()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 15 May 2011 00:30:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34492
Subject		: [2.6.39-rc4, x86_32] Stall at default_idle()
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2011-04-27 4:49 (18 days old)
Message-ID	: <201104270449.p3R4n54n023453@www262.sakura.ne.jp>
References	: http://marc.info/?l=linux-kernel&m=130387977425687&w=2


