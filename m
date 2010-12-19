Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0LSMmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:42:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab0LSMlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:41:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
In-Reply-To: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6Ue85L6pKCJ.A.-kD._dfDNB@chimera>
Subject: [Bug #24762] BUG at perf_ctx_adjust_freq (kernel/perf_event.c:1582)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:34:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24762
Subject		: BUG at perf_ctx_adjust_freq (kernel/perf_event.c:1582)
Submitter	: Chris Wilson <chris@chris-wilson.co.uk>
Date		: 2010-12-10 12:00 (10 days old)
Message-ID	: <c6d829$pqibha@fmsmga001.fm.intel.com>
References	: http://marc.info/?l=linux-kernel&m=129198247531612&w=2


