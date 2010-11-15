Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab0KOTHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:07:47 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54006 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490Ab0KOTHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:07:46 -0500
Date: Mon, 15 Nov 2010 19:07:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 44/44] sound/soc/codecs: Remove unnecessary semicolons
Message-ID: <20101115190738.GF3338@sirena.org.uk>
References: <cover.1289789604.git.joe@perches.com> <97fd199b7dac50613f6843156687223928cce44a.1289789605.git.joe@perches.com> <20101115134939.GC12986@rakim.wolfsonmicro.main> <1289840957.16461.138.camel@Joe-Laptop> <20101115173031.GI12986@rakim.wolfsonmicro.main> <1289842444.16461.140.camel@Joe-Laptop> <20101115182708.GJ12986@rakim.wolfsonmicro.main> <1289845830.16461.149.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289845830.16461.149.camel@Joe-Laptop>
X-Cookie: Who messed with my anti-paranoia shot?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 10:30:29AM -0800, Joe Perches wrote:
> On Mon, 2010-11-15 at 18:27 +0000, Mark Brown wrote:
> > On Mon, Nov 15, 2010 at 09:34:04AM -0800, Joe Perches wrote:

> > > I think it's more important to use consistent changelogs
> > > for a patch series.

> > ...since...?

> 1995...

That's not really a reason.  It seems that...

> Since there isn't a consistent standard for subsystems
> changelogs and automating scripts for the desires of
> individual subsystem maintainers is not feasible.

...you mean that you wish to do this since it makes your life as a
script author easier.  I'd suggest using pattern matching to look up the
rules for generating the prefixes (it's pretty much entirely prefixes)
in the same way you're handling figuring out who to mail - that'd
probably cover it in an automatable fashion.
