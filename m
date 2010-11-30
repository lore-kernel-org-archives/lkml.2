Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0K3Qxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:53:37 -0500
Received: from mailhost-y9-m4.netultra.net ([78.40.49.244]:56580 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751468Ab0K3Qxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:53:36 -0500
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
References: <20101109185516.GQ8332@bombadil.infradead.org>
	<1289329348.2191.69.camel@laptop>
	<20101110034507.GV8332@bombadil.infradead.org>
	<1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	<20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop>
	<1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette>
	<1291030726.32004.4.camel@laptop> <20101129194041.GA8280@roll>
	<1291071677.32004.527.camel@laptop>
	<1291129145.32004.874.camel@laptop>
Date: Tue, 30 Nov 2010 17:53:13 +0100
In-Reply-To: <1291129145.32004.874.camel@laptop> (Peter Zijlstra's message of
	"Tue, 30 Nov 2010 15:59:05 +0100")
Message-ID: <877hfueosm.fsf@free.fr>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [101130 15:59]:
> OK, so here's a less crufty patch that gets the same result on my
> machine, load drops down to 0.00 after a while.

Seems OK too here.

> It seems a bit slower to reach 0.00, but that could be because
> I actually changed the load computation for NO_HZ=n as well, I added
> a rounding factor in calc_load(), we no longer truncate the division.

Yes, really feels slower, but in the two configurations as you write.
Then this is a matter of convention, do not know which version is more
"correct" or "natural", but this is coherent in the two modes (HZ and
NO_HZ).

Do you plan to push this one to upstream/stable, or do you plan further
modifications?


Thanks for your patches,
-- 
Damien Wyart
