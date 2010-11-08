Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0KHXaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:30:01 -0500
Received: from www.tglx.de ([62.245.132.106]:50415 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab0KHXaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:30:00 -0500
Date: Tue, 9 Nov 2010 00:29:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings
In-Reply-To: <4CD8664C.7090007@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1011082221160.2900@localhost6.localdomain6>
References: <1289159606-17417-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.00.1011081824320.2900@localhost6.localdomain6> <4CD8664C.7090007@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Mon, 8 Nov 2010, Andi Kleen wrote:
> On 11/8/2010 8:36 PM, Thomas Gleixner wrote:
> > On Sun, 7 Nov 2010, Andi Kleen wrote:
> > > [Andrew, can you please put this in your tree for submission.
> > > This was submitted some time ago, but x86@ is a blackhole unfortunately
> > > and
> > You are about to create a blackhole by earning yourself an entry in my
> > killfile. I'm really fed up with your sneaky and priggish attacks.
> 
> Hi Thomas,
> 
> It's unfortunately not the only patch to which this happened. Losing patches
> is very common for x86@ based on my experience, the rate seems to be far
> far above 50%, more often even higher. I don't know what the problem
> is either, but it's very visible to me.
> 
> I would certainly not make such a comment without having
> sufficient data to back it up.

Then let's look at the data. 

All patches which are cc'ed to x86@kernel.org or tglx@linutronix.de
end up in a separate mbox. Here is the list since 01/01/2010 with the
reaction times documented

Subject: [PATCH] [2/9] Add a kernel_address() that works for data too

 Not x86 specific

Subject: [PATCH] x86: mce: Xeon75xx specific interface to get corrected

 Commit-ID:  c773f70fd6b53ee646727f871833e53649907264
 Gitweb:     http://git.kernel.org/tip/c773f70fd6b53ee646727f871833e53649907264
 Author:     Andi Kleen <andi@firstfloor.org>
 AuthorDate: Thu, 21 Jan 2010 23:17:12 +0100
 Committer:  H. Peter Anvin <hpa@zytor.com>
 CommitDate: Thu, 21 Jan 2010 17:38:20 -0800

Subject: [PATCH] Add Xeon 7500 series support to oprofile

 Commit-ID:  e83e452b0692c9c13372540deb88a77d4ae2553d
 Gitweb:     http://git.kernel.org/tip/e83e452b0692c9c13372540deb88a77d4ae2553d
 Author:     Andi Kleen <andi@firstfloor.org>
 AuthorDate: Thu, 21 Jan 2010 23:26:27 +0100
 Committer:  Robert Richter <robert.richter@amd.com>
 CommitDate: Mon, 25 Jan 2010 15:34:53 +0100

Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll

 Commit-ID:  757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c
 Gitweb:     http://git.kernel.org/tip/757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c
 Author:     Andi Kleen <andi@firstfloor.org>
 AuthorDate: Sat, 23 Jan 2010 12:33:59 +0100
 Committer:  H. Peter Anvin <hpa@zytor.com>
 CommitDate: Fri, 5 Feb 2010 14:51:53 -0800

Subject: [PATCH] HPET: Drop WARN_ON for mismatch on HPET CMP readback

 Solved differently after technical discussion with
  commit 8da854cb02156c90028233ae1e85ce46a1d3f82c
  Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
  Date:   Thu Feb 25 10:53:48 2010 -0800

Subject: [PATCH] Allow Intel platforms to declare unsynchronized TSC to

  Seems to be missed, but no reminder

Subject: [PATCH] x86: mce: Xeon75xx specific interface to get corrected

  Questioned by Hidetoshi.

Subject: [PATCH] Prevent nested interrupts when the IRQ stack is near

  Solved differently.

Subject: [PATCH] [REGRESSION 2.6.33] x86: Handle overlapping mptables

  Commit-ID:  909fc87b32b3b9e3f0b87dcc5d98319c41900c58
  Gitweb:     http://git.kernel.org/tip/909fc87b32b3b9e3f0b87dcc5d98319c41900c58
  Author:     Andi Kleen <andi@firstfloor.org>
  AuthorDate: Mon, 29 Mar 2010 09:41:11 +0200
  Committer:  H. Peter Anvin <hpa@zytor.com>
  CommitDate: Thu, 1 Apr 2010 13:31:07 -0700

Subject: [PATCH] [1/23] x86: percpu: Avoid warnings of unused variables in per cpu

  Commit-ID:  157a9df3b0f8042f1a6a4fe9e0e494431aaca1ae
  Gitweb:     http://git.kernel.org/tip/157a9df3b0f8042f1a6a4fe9e0e494431aaca1ae
  Author:     Andi Kleen <andi@firstfloor.org>
  AuthorDate: Thu, 10 Jun 2010 13:10:36 +0200
  Committer:  Ingo Molnar <mingo@elte.hu>
  CommitDate: Thu, 10 Jun 2010 14:09:30 +0200

Subject: [PATCH] [2/23] IRQ: Move alloc_desk_mask variables inside ifdef

 Commit-ID:  1813a68457bb45b378d5bbec615b167deff3bcfc
 Gitweb:     http://git.kernel.org/tip/1813a68457bb45b378d5bbec615b167deff3bcfc
 Author:     Andi Kleen <andi@xxxxxxxxxxxxxx>
 AuthorDate: Tue, 20 Jul 2010 15:22:54 -0700
 Committer:  Thomas Gleixner <tglx@xxxxxxxxxxxxx>
 CommitDate: Tue, 27 Jul 2010 20:43:05 +0200

Subject: [PATCH] [3/23] x86: Avoid unused by set variables in rdmsr

 Commit-ID:  5f755293ca61520b70b11afe1b1d6e1635cb6c00
 Gitweb:     http://git.kernel.org/tip/5f755293ca61520b70b11afe1b1d6e1635cb6c00
 Author:     Andi Kleen <andi@firstfloor.org>
 AuthorDate: Tue, 20 Jul 2010 15:19:48 -0700
 Committer:  H. Peter Anvin <hpa@linux.intel.com>
 CommitDate: Tue, 20 Jul 2010 15:38:18 -0700

Subject: [PATCH] [7/23] x86: fix set but not read variables

 Commit-ID:  fa10ba64ac94fec4611b79804023eb087862ffe0
 Gitweb:     http://git.kernel.org/tip/fa10ba64ac94fec4611b79804023eb087862ffe0
 Author:     Andi Kleen <andi@xxxxxxxxxxxxxx>
 AuthorDate: Tue, 20 Jul 2010 15:19:49 -0700
 Committer:  H. Peter Anvin <hpa@xxxxxxxxxxxxxxx>
 CommitDate: Tue, 20 Jul 2010 15:38:30 -0700

Subject: [PATCH] Remove implicit list prefetches for most cases
Subject: [PATCH 1/2] Add for_each_module iterator function
Subject: [PATCH 2/2] Rewrite jump_label.c to use binary search
Subject: [PATCH] Convert preempt_disabled in module.c to rcu read lock
Subject: [PATCH 1/2] Add for_each_module iterator function v2
Subject: [PATCH 2/2] Rewrite jump_label.c to use binary search v2

 Not x86 patches. Separate discussion and not my topic.

Subject: [PATCH 1/2] Encode huge page size for VM_FAULT_HWPOISON errors
Subject: [PATCH 2/2] x86: HWPOISON: Report correct address granuality for huge hwpoison faults

 Missed, no polite reminder. Just a nastigram in the pull request,
 nevertheless acked by Ingo.

Subject: [PATCH] Fix written but not read warnings for x2apic.h

 Delayed by 12 days for known reasons

Subject: [PATCH] x86: fix apic.h unused but set warnings

 Nastigram with a changed subject line

To summarize:

   - There is a single patch missed in 2010
     [PATCH] Allow Intel platforms to declare unsynchronized TSC to

   - There were two patches not reviewed, but pushed by yourself and
     acked after Ingo noticed

     Subject: [PATCH 1/2] Encode huge page size for VM_FAULT_HWPOISON errors
     Subject: [PATCH 2/2] x86: HWPOISON: Report correct address granuality for huge \
hwpoison faults

   - There were eight patches applied within a few days after posting

   - There was one patch questioned by Hidetoshi and we never got a
     resolution

   - There were two patches which got not applied because the
     discussion resolved it differently

So that makes _ONE_ patch out of 14 being missed. That's hardly close
to 50%.

> In fact I don't ping most patches, but had to do it for this one
> because the problem is just too noticeable.
>
> Anyways it's easy to avoid such comments too: don't lose patches as often
> I would be happy if I didn't need to send any of these reminders. However

Reminder?

A reminder looks like this: "Hi, this is a resend of the patch I sent
<date>, and was wondering if it got lost during your trip to
KS/Plumbers" or "ping, did this get lost ?"

What you wrote was an attack instead. One in a long series of sneaky
attacks. It's just the last one I'm going to read.

> at this loss rate you cannot expect nice comments.

Consider your loss rate 100% from now on. You managed to be the 3rd
person who made it into my killfile in 15 years. Feel well in the
company of Uwe Bugla and Florian Mickler. That's an achievement!

Thanks,

	tglx
