Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab0JDRzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:55:48 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57994 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756312Ab0JDRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:55:46 -0400
Date: Mon, 4 Oct 2010 19:55:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-trace-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jean Pihet <jean.pihet@newoldbits.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        arjan@infradead.org
Subject: Re: [linux-pm] [PATCH] tracing, perf: add more power related events
Message-ID: <20101004175536.GD1518@ucw.cz>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
 <201009222049.18154.rjw@sisk.pl>
 <AANLkTinJU5+s_1S6i4GpRuiOfsAPiL9UFtrxCCbtoumt@mail.gmail.com>
 <201009282322.16291.rjw@sisk.pl>
 <4CA261F4.5070803@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA261F4.5070803@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Here is what I am proposing, in reply to all your comments:
> >>
> >> 1) rename the events to match Thomas's proposal:
> >>     power:power_cpu_cstate
> >>     power:power_cpu_pstate
> >>     power:power_cpu_sstate
> > If that sstate thing is going to mean "suspend", then please drop it.
> > "Suspend" is not a state, let alone a CPU state.  It is a procedure by which
> > the (entire) system is put into a sleep state (that is not confined to CPUs).
> 
> there are also non-suspend S states, like S0i1 and S0i3 (supported in 
> the current Intel "Moorestown" platform)

Where can one learn more?
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
