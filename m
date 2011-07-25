Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1GYMgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:36:38 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:45731 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1GYMga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:36:30 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
In-Reply-To: <20110725103817.GA21683@infradead.org>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
	 <4E2CA6DE.4040900@web.de>
	 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
	 <20110725075305.GA32294@elte.hu>
	 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
	 <20110725103817.GA21683@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 25 Jul 2011 15:36:27 +0300
Message-ID: <1311597387.14203.23.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, 2011-07-25 at 06:38 -0400, Christoph Hellwig wrote:
> On Mon, Jul 25, 2011 at 10:14:13AM +0200, Alexander Graf wrote:
> > So instead of thinking a bit and trying to realize that there might be a reason people don't want all their user space in the kernel tree you go ahead and start your own crusade of creating a new user space. Great. That's how I always hoped Linux would be :(.
> 
> It's not Linux in general yet, it's mostly a crusade of a few with a
> political agenda.

Would you mind sharing with the rest of us who exactly those few are and
what is their political agenda? I certainly don't recognize myself or
any of the development team from your description above. And to be
completely honest, I think that's one of the single most stupid comments
I've read in this thread.

On Mon, 2011-07-25 at 06:38 -0400, Christoph Hellwig wrote:
> And another argument, calling toyvisor2 "kvm" is a really bad idea.  The
> kvm binary has been used for the kvm-patched qemu binary for quite a
> while in various distros, so re-using that name will cause utter
> confusion.

I don't foresee 'utter confusion'. The code definitely wants to live in
tools/kvm so it's logical that the executable name is called 'kvm'. If
distros want to package it with a different name, they're free to do so.

> I'm happy that you guys do another independent userspace for kvm, but
> please:
> 
>   a) give it a useful name

I don't think toyvisor2 will do, really. I originally wanted to call the
hypervisor 'pvm' for selfish reasons because quite frankly 'penix' just
doesn't have the prestige 'linux' has. However, Ingo convinced me that
'kvm' is a good name and I agree with that.

I'm open to alternative suggestions, though.

>   b) just develop it where it belongs, your own little git repository
>      somewhere

I already explained why we want it in the kernel tree and what kind of
benefits we think there are. I also explained that we want to reuse and
share code with perf, for example. If you really want to argue against
merging, you need to cough up some actual disadvantages or refute the
suggested advantages.

			Pekka

