Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0IVSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:09:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab0IVSJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:09:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Wed, 22 Sep 2010 20:09:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>, Thomas Renninger <trenn@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Len Brown <len.brown@intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com> <4C9A21AD.1000800@linux.intel.com>
In-Reply-To: <4C9A21AD.1000800@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009222009.02011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010, Arjan van de Ven wrote:
>   On 9/22/2010 8:31 AM, Jean Pihet wrote:
> > Hi,
> >
> > Here is a patch that redefines the power events API. The advantages
> > are: easier maintainance of the kernel and the
> > user space tools, a cleaner and more generic interface, more
> > parameters for fine tracing and even documentation!
> >
> > Thomas, this patch has your patch above merged in ('power-trace: Use
> > power_switch_state instead of power_start and power_end'). The revised
> > ACPI patch is coming asap.
> >
> > The trace points for x86 and OMAP are also udated accordingly.
> >
> > The pytimechart tool needs an update for the new API. This can be done
> > as soon as the kernel code gets merged in.
> 
> unfortunately this code is changing a userspace ABI... we really 
> shouldn't do that if we can avoid it,
> and here we can avoid it.
> 
> applications ARE using this stuff!

Apart from this, could we rename things like POWER_CSTATE to CPU_POWER_CSTATE
and state clearly in the docs that this whole thing is about CPU power?

Thanks,
Rafael
