Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1KVSeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:34:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40723 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1KVSeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:34:12 -0500
Date: Tue, 22 Nov 2011 18:34:08 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Alessandro Rubini <rubini@unipv.it>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [GIT PULL] ARM: amba: Enable module alias autogeneration for
 AMBA drivers
Message-ID: <20111122183408.GI2066@localhost.localdomain>
References: <20111122120756.GF2066@localhost.localdomain>
 <1321961573-4562-1-git-send-email-dave.martin@linaro.org>
 <20111122115632.GA5165@mail.gnudd.com>
 <20111122151942.GA24821@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122151942.GA24821@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 04:19:42PM +0100, Alessandro Rubini wrote:
> >>   lkml.org/lkml/2011/11/4/125 (0/2: description of the work)
> >>   lkml.org/lkml/2011/11/4/126 (1/2: turn the if plethora to table lookup)
> >>   lkml.org/lkml/2011/11/4/127 (2/2: partial split to type-specific files).
> > 
> > Splitting this up doesn't look like a silly idea -- I thought it was
> > unfortunate to have to patch a core file just to add a bus type.
> >
> > I guess the question is how many new buses we get over time.
> 
> Well, CERN will have 2 in a short time. And I'm sure the bus concept
> is so good that a number of them exists as external patches. Being
> forced to patch a core file is not good, with conflicts that accumulate
> over time.
> 
> I'd better be able to drop in my own file and add a kconfig-aware line
> in Makefile.  I think the implementation is straightforward. Who should
> I send it to?

I'm afraid I can't help there -- I don't often dabble in core kernel stuff.

I didn't receive any response on my patches to those files, so it's possible
I was CC'ing the wrong people.  I did do my best dith git blame/log,
get_maintainer.pl and the rest and posted to lkml a couple of times though.

If I'm reading MAINTAINERS correctly, Michal Marek might be the default
maintainer for stuff in scripts/ not owned by other people... the way that
is described is not understood by get_maintainer.pl, it appears.

Marek, are you the correct person for scripts/mod/file2alias.c and related
stuff?

Cheers
---Dave
