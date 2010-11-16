Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab0KPXBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:01:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57242 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756844Ab0KPXBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:01:20 -0500
Date: Tue, 16 Nov 2010 23:01:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Florian Mickler <florian@mickler.org>, Joe Perches <joe@perches.com>,
        Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
Message-ID: <20101116230126.GB24623@opensource.wolfsonmicro.com>
References: <1289848458.16461.150.camel@Joe-Laptop>
 <20101115193407.GK12986@rakim.wolfsonmicro.main>
 <1289850773.16461.166.camel@Joe-Laptop>
 <20101116104921.GL12986@rakim.wolfsonmicro.main>
 <1289919077.28741.50.camel@Joe-Laptop>
 <20101116183707.179964dd@schatten.dmk.lab>
 <20101116181226.GB26239@rakim.wolfsonmicro.main>
 <20101116203522.65240b18@schatten.dmk.lab>
 <20101116195530.GA7523@rakim.wolfsonmicro.main>
 <20101116122102.86e7e0b9.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116122102.86e7e0b9.rdunlap@xenotime.net>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 12:21:02PM -0800, Randy Dunlap wrote:

> I don't know what you asked Joe to change, but asking someone to use
> the documented canonical patch format:

> <quote>
> The canonical patch subject line is:

>     Subject: [PATCH 001/123] subsystem: summary phrase
> </quote>

> should be fine.  And there is no need for printf-ish templates
> for this in MAINTAINERS either.

That's exactly what I asked him to do.  He said he's not willing to use
anything for "subsystem" which can't be automatically generated.

The formats I mentioned because some subsystems have their own things
within this format like "subsystem: driver:" or whatever.  While it's
probably not an issue for the sort of patch Joe generates if we do have
a tool for this I'd expect it'll go the same way that checkpatch does
and get used by people doing more specific work.  It'd be good to try to
head off the friction that may cause by at least having an idea how we
might cope with that.
