Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0IVR6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:58:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:54665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab0IVR6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:58:30 -0400
From: Thomas Renninger <trenn@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Wed, 22 Sep 2010 19:57:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1.99.9.f8e4270-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com> <4C9A21AD.1000800@linux.intel.com>
In-Reply-To: <4C9A21AD.1000800@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221957.57845.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 September 2010 17:33:01 Arjan van de Ven wrote:
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
Wow, this is your first post on this thread and you needed 1 min, 20 secs
to reply and comment on work that probably took several weeks and which is quite
an improvement.
You did not even start to read the documentation/patch in this minute, did you?

> applications ARE using this stuff!
The current interfaces do not make sense at all.
Things must be changed now before even more ARE using the broken stuff
and things get more complicated.
You should be happy that someone is helping/doing it.

    Thomas

