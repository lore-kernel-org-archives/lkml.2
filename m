Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0I1WGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:06:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50854 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab0I1WG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:06:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Wed, 29 Sep 2010 00:05:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009282322.16291.rjw@sisk.pl> <AANLkTin7yoSArdMTMSxKyamMP-dk7bubPiCEgWGb6RCc@mail.gmail.com>
In-Reply-To: <AANLkTin7yoSArdMTMSxKyamMP-dk7bubPiCEgWGb6RCc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009290005.51644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 28, 2010, Jean Pihet wrote:
> Hi,
> 
> On Tue, Sep 28, 2010 at 11:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, September 28, 2010, Jean Pihet wrote:
> >> Hi,
> >
> > Hi,
> >
> >> Here is what I am proposing, in reply to all your comments:
> >>
> >> 1) rename the events to match Thomas's proposal:
> >>    power:power_cpu_cstate
> >>    power:power_cpu_pstate
> >>    power:power_cpu_sstate
> >
> > If that sstate thing is going to mean "suspend", then please drop it.
> > "Suspend" is not a state, let alone a CPU state.  It is a procedure by which
> > the (entire) system is put into a sleep state (that is not confined to CPUs).
> 
> Since suspend is tied to the power management of the system, is it ok
> to rename it to e.g. power:system_suspend?

I think so.

Thanks,
Rafael
