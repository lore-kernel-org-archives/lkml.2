Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1DHHKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:10:39 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60376 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1DHHKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:10:38 -0400
Date: Fri, 8 Apr 2011 15:47:12 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Pekka Enberg <penberg@kernel.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-Id: <20110408154712.8319bf74.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
	<BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0beta2 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hi Anthony,
> 
> On Fri, Apr 8, 2011 at 5:14 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> > If someone was going to seriously go about doing something like this, a
> > better approach would be to start with QEMU and remove anything non-x86 and
> > all of the UI/command line/management bits and start there.
> >
> > There's nothing more I'd like to see than a viable alternative to QEMU but
> > ignoring any of the architectural mistakes in QEMU and repeating them in a
> > new project isn't going to get there.
> 
> Hey, feel free to help out! ;-)
> 
> I don't agree that a working 2500 LOC program is 'repeating the same
> architectural mistakes' as QEMU. I hope you realize that we've gotten
> here with just three part-time hackers working from their proverbial
> basements. So what you call mistakes, we call features for the sake of
> simplicity.
> 
> I also don't agree with this sentiment that unless we have SMP,
> migration, yadda yadda yadda, now, it's impossible to change that in
> the future. It ignores the fact that this is exactly how the Linux
> kernel evolved and the fact that we're aggressively trying to keep the
> code size as small and tidy as possible so that changing things is as
> easy as possible.

Is it possible to find the code maintenance policy on a project site
or somewhere?  -- for both short run and long run.

I may get some interest in using this tool for my debugging/testing/
self-educational porpuses, but cannot know what I can do/expect.

Takuya
  For me, both QEMU and Native Linux KVM tool may be useful! :)
  But it is, probably I guess, for different porposes.


> 
> I've looked at QEMU sources over the years and especially over the
> past year and I think you might be way too familiar with its inner
> workings to see how complex (even the core code) has become for
> someone who isn't familiar with it. I think it has to do with lots of
> indirection and code cleanliness issues (and I think that was the case
> even before KVM came into the picture). So I don't agree at all that
> taking QEMU as a starting point would make things any easier. (That
> is, unless someone intimately familiar with QEMU does it.)

-- 
Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
