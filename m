Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1DMT1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:27:03 -0400
Received: from 8bytes.org ([88.198.83.132]:38440 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab1DMT1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:27:00 -0400
Date: Wed, 13 Apr 2011 21:26:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110413192659.GK19819@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5EDE1.3030600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5EDE1.3030600@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 11:39:29AM -0700, H. Peter Anvin wrote:
> On 04/13/2011 10:21 AM, Joerg Roedel wrote:
> > On Wed, Apr 13, 2011 at 08:46:09AM +0200, Ingo Molnar wrote:
> >> Could you please send the before/after bootlog (in particular all memory init 
> >> messages included) and your .config?
> >>
> >>  before:  f005fe12b90c: x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
> >>   after:  d2137d5af425: Merge branch 'linus' into x86/bootmem
> >>
> >> I've Cc:-ed more people who might have an idea about it.
> > 
> > Okay, I have done some more bisecting and debugging today.
> > 
> 
> First of all, *huge* thanks for this effort.  At least we need to track
> down the bits that need to be reverted -- it is past rc3, and it's time
> to see what we should revert and tell the submitter to try again next cycle.
> 
> This looks to be the same issue as in bugzilla 33012:
> 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=33012
> 
> ... so it would be good if we could keep the information in there.

Yes, I try to find my korg bugzilla account again and drop the
information from this email there.

	Joerg

