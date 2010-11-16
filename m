Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab0KPKt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:49:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37436 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932992Ab0KPKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:49:24 -0500
Date: Tue, 16 Nov 2010 10:49:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 44/44] sound/soc/codecs: Remove unnecessary semicolons
Message-ID: <20101116104921.GL12986@rakim.wolfsonmicro.main>
References: <20101115134939.GC12986@rakim.wolfsonmicro.main>
 <1289840957.16461.138.camel@Joe-Laptop>
 <20101115173031.GI12986@rakim.wolfsonmicro.main>
 <1289842444.16461.140.camel@Joe-Laptop>
 <20101115182708.GJ12986@rakim.wolfsonmicro.main>
 <1289845830.16461.149.camel@Joe-Laptop>
 <20101115190738.GF3338@sirena.org.uk>
 <1289848458.16461.150.camel@Joe-Laptop>
 <20101115193407.GK12986@rakim.wolfsonmicro.main>
 <1289850773.16461.166.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289850773.16461.166.camel@Joe-Laptop>
X-Cookie: I like your SNOOPY POSTER!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:52:53AM -0800, Joe Perches wrote:
> On Mon, 2010-11-15 at 19:34 +0000, Mark Brown wrote:

> > It appears your scripts are already hooked into get_maintainers.pl which
> > would seem the obvious place to do this?  Sadly I don't do perl, though
> > it looks like you're doing pretty much all the work on that anyway.

> Sadly, no it's not the right place.

To query MAINTAINERS?  I'd assume that's where you'd want to put that
stuff?

> There could be a modification to $1 (path)
> or some such.
> 
> Maybe a script like
> ./scripts/convert_commit_subject_to_subsystem_maintainer_taste
> or something.

> Care to write one in sh/bash/perl/python/c/ocaml/c#?

Like I say I'd expect this to be a get_maintainers based lookup to dump
some data out?

> As far as I know, the only subsystem pedants^H^H^H^H^Hople
> that care much about the commit subject style are
> arch/x86 and sound.

If you look at the kernel you'll see quite a few subsystems which have
some sort of standard practice which they do try to enforce, you
shouldn't take silence as people being happy here - it's taken me some
considerable time to get round to mentioning this, for example, and I
might not have bothered if the patch had applied first time around.
Like working against -next it's one of these things that would make your
patches easier to deal with.

> I can understand the desire of these subsystem maintainers
> to have a consistent style.  I think though that requiring
> a subject header style without providing more than a
> general guideline is a but much.

The general guideline I tend to go with is that if what you're doing
looks odd for the code you're submitting against for some reason you're
doing something wrong unless you understand why you're doing something
different and there's a good reason.

> I'd use any other automated tool you want to provide.

Like I say, I'd expect the lookup from the database to be handled by
get_maintainers.pl.  Having a separate database would seem odd.
