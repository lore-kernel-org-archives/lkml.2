Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab0LSMo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:44:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749Ab0LSMke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:40:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Don Zickus" <dzickus@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Yinghai Lu" <yinghai@kernel.org>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
In-Reply-To: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6Ue85L6pKCJ.A.EQE.UefDNB@chimera>
Subject: [Bug #24362] perf hw  in kexeced kernel broken in tip
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:34:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24362
Subject		: perf hw  in kexeced kernel broken in tip
Submitter	: Yinghai Lu <yinghai@kernel.org>
Date		: 2010-12-01 8:00 (19 days old)
First-Bad-Commit: http://git.kernel.org/linus/33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0
Message-ID	: <4CF60095.1020900@kernel.org>
References	: http://marc.info/?l=linux-kernel&m=129119055922065&w=2


