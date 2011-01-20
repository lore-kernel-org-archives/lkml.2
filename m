Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1ATCBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:01:34 -0500
Received: from mail.vyatta.com ([76.74.103.46]:42635 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab1ATCBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:01:33 -0500
Date: Wed, 19 Jan 2011 18:01:31 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Pekka Enberg <penberg@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block driver updates for 2.6.38
Message-ID: <20110119180131.088a7994@nehalam>
In-Reply-To: <AANLkTimZWMJQfc6E-ke+SbpaTeG9UKA--g=qFQa+11aW@mail.gmail.com>
References: <4D2F03F2.4000707@fusionio.com>
	<AANLkTi=t9FQaUhnXCk51bjZO82F8OGDDd9H5HyMPRPQd@mail.gmail.com>
	<4D2F51B5.6060105@fusionio.com>
	<AANLkTi=PDEyJNN3aKhHWzCKrTfzib-VCdvgD7auoWuzD@mail.gmail.com>
	<20110113141957.1eaf4940@nehalam>
	<AANLkTikdULkbB83Us_zXivv8Y5FGdHrixUXRiitacaSh@mail.gmail.com>
	<20110113161115.1d564448@nehalam>
	<AANLkTimZWMJQfc6E-ke+SbpaTeG9UKA--g=qFQa+11aW@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011 17:03:21 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 13, 2011 at 4:11 PM, Stephen Hemminger
> <shemminger@vyatta.com> wrote:
> >
> > It appears to be a different problem (not HPET MSI). Not sure what
> > is causing it, but even 2.6.35 can't format a floppy without error.
> 
> Do you actually know that the hardware is good (ie does _any_ version
> of Linux work)?
> 
> Floppy disks and drives have not been known for their robustness, and
> most of them tend to be pretty old by now.
> 
> Dang, I think I should just try to go to Fry's and see if I can find a
> floppy drive somewhere. Not that I even know if my motherboards
> necessarily even have the _pins_ to connect it any more.

I could not find a working floppy in 4 machines (even Windows).

There is always USB floppy but it is not the same.
