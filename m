Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1DQM6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 08:58:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56649 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1DQM5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 08:57:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        "Don Zickus" <dzickus@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Shaun Ruffell" <sruffell@digium.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
In-Reply-To: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_H4l51C1wXN.A.WiB.dGuqNB@chimera>
Subject: [Bug #33252] [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper MSR register to catch" and NMIs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 14:57:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33252
Subject		: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper MSR register to catch" and NMIs
Submitter	: Shaun Ruffell <sruffell@digium.com>
Date		: 2011-04-06 22:30 (12 days old)
First-Bad-Commit: http://git.kernel.org/linus/242214f9c1eeaae40eca11e3b4d37bfce960a7cd
Message-ID	: <20110406223036.GA15721@digium.com>
References	: http://marc.info/?l=linux-kernel&m=130212907032580&w=2
Handled-By	: Don Zickus <dzickus@redhat.com>
Patch		: http://cache.gmane.org//gmane/linux/kernel/1125621-001.bin


