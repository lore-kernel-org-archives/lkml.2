Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0FXTMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:12:22 -0400
Received: from mail.atheros.com ([12.36.123.2]:54956 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0FXTMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:12:21 -0400
Date: Thu, 24 Jun 2010 12:12:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sankar P <sankar.curiosity@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
       Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>, <mcgrof@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: kmemleak: Change kmemleak default buffer size
Message-ID: <20100624191218.GC6031@tux>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com>
 <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
 <20100622165509.GB11336@tux>
 <AANLkTikHiPKPD5myvn8bycPAS4f9rBkPvbag6if7p23O@mail.gmail.com>
 <20100624185614.GA6031@tux>
 <AANLkTim4mjw0BFshK_4RS6oDLLQMH_BF7BklU7EhETSj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTim4mjw0BFshK_4RS6oDLLQMH_BF7BklU7EhETSj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 12:01:51PM -0700, Sankar P wrote:
> On Fri, Jun 25, 2010 at 12:26 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Thu, Jun 24, 2010 at 12:31:11AM -0700, Sankar P wrote:
> >> On Tue, Jun 22, 2010 at 10:25 PM, Luis R. Rodriguez
> >> <lrodriguez@atheros.com> wrote:
> >> > On Mon, Jun 21, 2010 at 11:58:29PM -0700, Sankar P wrote:
> >> >> If we try to find the memory leaks in kernel that is
> >> >> compiled with 'make defconfig', the default buffer size
> >> >> seem to be inadequate. Change the buffer size from
> >> >> 400 to 1000, which is sufficient in most cases.
> >> >>
> >> >> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
> >> >
> >> > What's your full name? Please read the "Developer's Certificate of Origin 1.1"
> >> > It says:
> >> >
> >> > then you just add a line saying
> >> >
> >> >        Signed-off-by: Random J Developer <random@developer.example.org>
> >> >
> >> > using your real name (sorry, no pseudonyms or anonymous contributions.)
> >> >
> >> >
> >> > Also you may want to post on a new thread instead of using this old thread
> >> > unless the maintainer is reading this and wants to pick it up.
> >> >
> >>
> >> In our part of the world, we dont have lastnames. We just use the
> >> first letter of our father's name as the last name.
> >
> > Oh wow, what part of the world is that? Interesting.
> >
> 
> 
> It is in a place called "Tamil Nadu" in India. See
> http://en.wikipedia.org/wiki/Indian_name (First paragraph end)

Odd, I visited Tamil Nadu for a while and met quite a few folks who
have full last names, like the ones Cc'd. Does this differ between
area or what?

> >> I will send the updated patch as a new mail, I thought it will be
> >> easier to follow if all mails belongs to the same thread.
> >
> > It does help in-thread, but patches should be sent separately unless
> > you know for sure the maintainer *will* read this.
> >
> 
> Okay I will take care next time. Thanks for the advice.
> 
> Sent this off-thread as I was not sure if people might like talking
> about "Names"  in LKML.

Actually it is important since the SOB is part of the development
process. If we cannot gaurantee names on the SOB then that needs
to be known too.

  Luis
