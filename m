Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0JTUZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:25:04 -0400
Received: from mailhost-w0-m3.mangoosta.org ([78.40.49.225]:52883 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347Ab0JTUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:25:03 -0400
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
References: <20100929070153.GA2200@brouette> <20101014145813.GA2185@brouette>
	<20101020132732.GA30024@brouette> <1287581440.3488.16.camel@twins>
	<1287582208.3488.20.camel@twins> <1287584073.3488.22.camel@twins>
	<1287595605.3488.52.camel@twins>
Date: Wed, 20 Oct 2010 22:24:37 +0200
In-Reply-To: <1287595605.3488.52.camel@twins> (Peter Zijlstra's message of
	"Wed, 20 Oct 2010 19:26:45 +0200")
Message-ID: <87bp6ozk6y.fsf@free.fr>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [101020 19:26]:
> OK, how does this work for people? I find my idle load is still a tad
> high, but maybe I'm not patient enough.

Looks quite fine after some basic tests, much saner than without the
patch. A bit slow to go down, but I reach 0.00 after enough time being
idle.

Can't tell about the behavior after hours of uptime, of course, but the
values during the first minutes after bootup seems OK; without the
patch, they are evidently wrong...

Maybe commit this after some more reviews in the next 1 or 2 days, and
maybe think about further tweaking during 2.6.37?

-- 
Damien
