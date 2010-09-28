Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab0I1WGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:06:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50842 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0I1WGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:06:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Wed, 29 Sep 2010 00:05:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>, Thomas Renninger <trenn@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Len Brown <len.brown@intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009282322.16291.rjw@sisk.pl> <4CA261F4.5070803@linux.intel.com>
In-Reply-To: <4CA261F4.5070803@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009290005.18704.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 28, 2010, Arjan van de Ven wrote:
>   On 9/28/2010 2:22 PM, Rafael J. Wysocki wrote:
> > On Tuesday, September 28, 2010, Jean Pihet wrote:
> >> Hi,
> > Hi,
> >
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
> 
> so it's slightly more complex than "just" suspend :)

That's exactly why I used the conditional above. :-)
