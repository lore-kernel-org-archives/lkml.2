Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0KOTeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:34:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43423 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757933Ab0KOTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:34:10 -0500
Date: Mon, 15 Nov 2010 19:34:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 44/44] sound/soc/codecs: Remove unnecessary semicolons
Message-ID: <20101115193407.GK12986@rakim.wolfsonmicro.main>
References: <cover.1289789604.git.joe@perches.com>
 <97fd199b7dac50613f6843156687223928cce44a.1289789605.git.joe@perches.com>
 <20101115134939.GC12986@rakim.wolfsonmicro.main>
 <1289840957.16461.138.camel@Joe-Laptop>
 <20101115173031.GI12986@rakim.wolfsonmicro.main>
 <1289842444.16461.140.camel@Joe-Laptop>
 <20101115182708.GJ12986@rakim.wolfsonmicro.main>
 <1289845830.16461.149.camel@Joe-Laptop>
 <20101115190738.GF3338@sirena.org.uk>
 <1289848458.16461.150.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289848458.16461.150.camel@Joe-Laptop>
X-Cookie: I like your SNOOPY POSTER!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:14:18AM -0800, Joe Perches wrote:
> On Mon, 2010-11-15 at 19:07 +0000, Mark Brown wrote:

> > I'd suggest using pattern matching to look up the
> > rules for generating the prefixes (it's pretty much entirely prefixes)
> > in the same way you're handling figuring out who to mail - that'd
> > probably cover it in an automatable fashion.

> Publish a tool that works and I'll use it.

It appears your scripts are already hooked into get_maintainers.pl which
would seem the obvious place to do this?  Sadly I don't do perl, though
it looks like you're doing pretty much all the work on that anyway.

The main thing here is to avoid your patches sticking out - as well as
the hassle applying them stuff like this is also a red flag on review.
