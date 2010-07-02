Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0GBOBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:01:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63467 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0GBOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tzZM7ze0Cp3jRldDXdM+vI9tgmbZeqMVNK9Jw+V/HfRRUJtjoVRoyB+BEGey+KfoPP
         28brmJsalIPUxoOy0ylmn6ThuEyR4USuzjqWBU7zOzwQVWZv3PHMmm/4hnaJIhhFas9I
         9v9RdxgqALDosHfDMJ9IUN06jlkxANEIEk4ko=
Date: Fri, 2 Jul 2010 18:01:44 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luc Verhaegen <libv@skynet.be>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source
 kernel component
Message-ID: <20100702140144.GA27618@oksana.dev.rtsoft.ru>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
 <20100702095815.GA6802@skynet.be>
 <AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com>
 <20100702111029.GB6802@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100702111029.GB6802@skynet.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 01:10:29PM +0200, Luc Verhaegen wrote:
[...]
> > They'll keep shipping closed stuff, just like they are now. Are you
> > going to reverse engineer the userspace drivers, so people who care
> > about open and free software platforms can use these drivers? (or have
> > you already signed NDAs saying you can't). Why should we maintain a
> > bunch of kernel code, when they are hiding away all the really useful
> > stuff that people could improve.
> 
> Maintaining this exact code is not _your_ job, [...]

Correct, it's not solely his job, but it's also every kernel
developers' job.

When I change kernel API I have to grep through all the kernel
drivers, sometimes understand how they work, and then make the
change to the whole kernel source tree.

And I would not want to maintain this code, as these drivers
are wasting my time without returning anything back.

It was said many times. Actually, so many times that it started
to become boring to repeat, and the Kernel Driver Statement was
written:

"We, the undersigned Linux kernel developers, consider any
 closed-source Linux kernel module or driver to be harmful and
 undesirable."

http://www.linuxfoundation.org/collaborate/publications/kernel-driver-statement

While the doc mostly says "kernel code", I truly believe that
there's actually no huge difference between "closed-source
kernel module" and "open source dummy kernel module + userspace
blob".

Both are closed source solutions, and generally useless for the
open source. And, what is worse, the last one is harmful for me
personally.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
