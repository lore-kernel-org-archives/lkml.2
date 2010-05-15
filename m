Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936Ab0EOEEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 00:04:41 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:34188 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab0EOEEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 00:04:39 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005142233070.11498-100000@netrider.rowland.org>
References: <201005140028.49443.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.1005142233070.11498-100000@netrider.rowland.org>
Date: Fri, 14 May 2010 21:04:38 -0700
Message-ID: <AANLkTim7Gh7045xiEbnPSBFAWPmPstfi71zdgZb8KXD4@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Lindgren <tony@atomide.com>,
       Paul Walmsley <paul@pwsan.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, Matthew Garrett <mjg@redhat.com>,
       =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 7:35 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 14 May 2010, Rafael J. Wysocki wrote:
>
>> > > How do you handle situations where the CPU is currently idle but an
>> > > event (such as I/O completion) is expected to occur in the near future?
>> > > You don't want to power-off and reboot then, do you?
>> >
>> > The idle code looks at next_timer_interrupt() value, then if the
>> > next timer event if far enough ahead, the system powers down and
>> > wakes to the timer interrupt. It also wakes to device interrupts.
>>
>> For the record, waking to interrupts doesn't work on quite some systems
>> (like ACPI-based PCs for one example).
>
> Ironically, it appears that ACPI-based PCs are in a position to benefit
> more from opportunistic suspend and suspend blockers than are embedded
> systems -- and yet they are being proposed for use on cell phones
> rather than on desktops.
>

I would also use it on a desktop.

-- 
Arve Hjønnevåg
