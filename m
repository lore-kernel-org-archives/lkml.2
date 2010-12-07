Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0LGMtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:10 -0500
Received: from www.tglx.de ([62.245.132.106]:46597 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab0LGMtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:09 -0500
Message-Id: <20101207124527.868085529@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/9]  perf: Consolidate the event handling and ordering
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes an unbound array access and further
consolidates the event handling in session.c.

It now allows:

   - time ordered dumps
   - break time ordering when not all events provide timestamps

Thanks,

	tglx



