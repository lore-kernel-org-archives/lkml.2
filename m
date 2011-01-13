Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab1AMWUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:20:04 -0500
Received: from mail.vyatta.com ([76.74.103.46]:60197 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373Ab1AMWT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:19:59 -0500
Date: Thu, 13 Jan 2011 14:19:57 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block driver updates for 2.6.38
Message-ID: <20110113141957.1eaf4940@nehalam>
In-Reply-To: <AANLkTi=PDEyJNN3aKhHWzCKrTfzib-VCdvgD7auoWuzD@mail.gmail.com>
References: <4D2F03F2.4000707@fusionio.com>
	<AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
	<4D2F51B5.6060105@fusionio.com>
	<AANLkTi=PDEyJNN3aKhHWzCKrTfzib-VCdvgD7auoWuzD@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011 11:40:09 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 13, 2011 at 11:25 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> > On 2011-01-13 20:00, Linus Torvalds wrote:
> >> On Thu, Jan 13, 2011 at 5:53 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> >>>
> >>> Pekka Enberg (1):
> >>>      floppy: replace NO_GEOM macro with a function
> >>
> >> Hmm. When I see work on floppy.c, I end up wondering what happened to
> >> the work by Stephen to use a single threaded workqueue?
> >>
> >> That was reported to fix a KVM oops at some point to to avoiding the
> >> whole race between interrupts/workqueues, but it seems to have dropped
> >> off everybody's radar. I don't think anybody ever tested it on real
> >> hardware, but I'm still wondering..
> >
> > Not sure, I don't recall seeing it.
> 
> It was on lkml a few months ago. google finds it with "floppy: use
> single threaded workqueue" if you don't have your own archives.
> 
> Eg:
> 
>    http://kerneltrap.org/mailarchive/linux-kernel/2010/6/11/4582074
> 
> and similar.
> 
>                         Linus

It looks my floppy format problem wasn't my patch but the HPET-MSI
problem. https://patchwork.kernel.org/patch/69588/

Why hasn't that been fixed in mainline kernel?

-- 
