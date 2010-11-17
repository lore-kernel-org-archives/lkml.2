Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab0KQAxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:53:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265Ab0KQAxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:53:37 -0500
Date: Wed, 17 Nov 2010 01:53:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Florian Mickler <florian@mickler.org>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
In-Reply-To: <20101117014427.41d85b13@stein>
Message-ID: <alpine.LNX.2.00.1011170150060.7420@pobox.suse.cz>
References: <1289848458.16461.150.camel@Joe-Laptop> <20101115193407.GK12986@rakim.wolfsonmicro.main> <1289850773.16461.166.camel@Joe-Laptop> <20101116104921.GL12986@rakim.wolfsonmicro.main> <1289919077.28741.50.camel@Joe-Laptop> <20101116183707.179964dd@schatten.dmk.lab>
 <20101116181226.GB26239@rakim.wolfsonmicro.main> <20101116203522.65240b18@schatten.dmk.lab> <20101116195530.GA7523@rakim.wolfsonmicro.main> <20101116122102.86e7e0b9.rdunlap@xenotime.net> <20101116230126.GB24623@opensource.wolfsonmicro.com>
 <20101117014427.41d85b13@stein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Stefan Richter wrote:

> > > I don't know what you asked Joe to change, but asking someone to use
> > > the documented canonical patch format:
> > 
> > > <quote>
> > > The canonical patch subject line is:
> > 
> > >     Subject: [PATCH 001/123] subsystem: summary phrase
> > > </quote>
> > 
> > > should be fine.  And there is no need for printf-ish templates
> > > for this in MAINTAINERS either.
> > 
> > That's exactly what I asked him to do.  He said he's not willing to use
> > anything for "subsystem" which can't be automatically generated.
> 
> Why should we codify our conventions in MAINTAINERS to accommodate the
> specific problem of virtually a _single_ patch author?
> 
> Conventions are living and are being adjusted all the time, as code
> organization changes, people join and go, projects start and cease.
> 
> Said author please looks the conventions up in the git history.  If he
> finds that this decelerates his patch generation rate, he can surely
> code a script that looks into git for him and suggests plausible
> prefixes for his patch titles to him.  Or he can collect a kind of
> database (a config file) locally for his own use in which he records
> conventional prefixes on the go.

Come on guys, this debate is really horribly boring.

Either the maintainer wants the patch. Then he is certainly able to apply 
it no matter the subject line (I personally am getting a lot of patches 
which don't follow the format I am using in my tree ... converting 
Subject: lines is so trivial that I have never felt like bothering anyone 
about it ... it's basically single condition in a shellscript). Or the 
maintainer doesn't feel like the patch is worth it, and then the 
subject-line format really doesn't matter.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
