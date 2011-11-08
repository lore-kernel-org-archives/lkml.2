Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1KHGuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:50:20 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53780 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1KHGuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:50:17 -0500
Subject: Re: Linux 3.2-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 22:50:14 -0800
Message-ID: <1320735014.30780.172.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 18:10 -0800, Linus Torvalds wrote:
> So it's been two weeks since 3.1, and you know how it works by now.
> 
> I have to say, this wasn't my favorite merge window ever. I really
> wanted to take only things that had been in -next, but verifying it
> was fairly painful, since a lot of the trees had been rebased, and the
> ones that hadn't been rebased often had some extra patches that still
> showed up when I did my "git log linux-next..FETCH_HEAD" thing.
> 
> On the whole, most of it was all good, and I didn't really end up
> complaining to people. I'm pretty sure that there were trees I
> shouldn't have let through, but the majority really had been in -next.
> 
> The other point of irritation was that there really was a lot of stuff
> that came in yesterday and basically treated the merge window as some
> kind of high-tech limbo dance. If it hadn't been for a few trees I
> wanted to pull, I had actually planned to do the -rc1 release Sunday
> afternoon instead, just to cut those annoying last-minute pull
> requests off.
> 
> And some trees didn't get pulled. You know who you are, and you can
> try to appeal to my softer side if you think it was unfair. Of course,
> if you *do* find my softer side, please tell my wife and kids too,
> they'll be thrilled.
> 
> But the main reason some trees didn't get pulled was that they
> generated long flame-wars, and I just felt like I really didn't need
> the aggravation this time around, especially as I knew I had plenty
> other trees to pull.
> 

Hi Linus,

(Just asking once more, so if you're really over it please ignore the
following..)

Is there any chance to get a merge window exception for the ib_srpt
driver..?  We (Roland, Bart + myself) have agreed on the userspace
configfs API, and we collectively made forward progress without any
extra controversy or flames this time around.  A first in the history of
mainline target mode code development!

That said, ib_srpt has been getting build testing in linux-next and is a
stand-alone driver that does not modify any existing external code, so
the merge risk is nill.  The main reason I'm asking for the exception is
that we have a very time and resource intensive effort underway for v3.3
to get the qla2xxx FC target merged.  So if your not completely joking
about appealing to the benevolent dictator here, please consider making
an one time exception for ib_srpt.

Thank you for the extra consideration,

--nab

