Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab0KPX6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:58:00 -0500
Received: from mail.perches.com ([173.55.12.10]:1493 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab0KPX57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:57:59 -0500
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Florian Mickler <florian@mickler.org>,
        Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101116232258.GC24623@opensource.wolfsonmicro.com>
References: <1289850773.16461.166.camel@Joe-Laptop>
	 <20101116104921.GL12986@rakim.wolfsonmicro.main>
	 <1289919077.28741.50.camel@Joe-Laptop>
	 <20101116183707.179964dd@schatten.dmk.lab>
	 <20101116181226.GB26239@rakim.wolfsonmicro.main>
	 <20101116203522.65240b18@schatten.dmk.lab>
	 <20101116195530.GA7523@rakim.wolfsonmicro.main>
	 <20101116122102.86e7e0b9.rdunlap@xenotime.net>
	 <1289940156.28741.207.camel@Joe-Laptop>
	 <20101116124609.382e42fb.rdunlap@xenotime.net>
	 <20101116232258.GC24623@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 15:57:57 -0800
Message-ID: <1289951877.28741.262.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 23:22 +0000, Mark Brown wrote:
> On Tue, Nov 16, 2010 at 12:46:09PM -0800, Randy Dunlap wrote:
> > On Tue, 16 Nov 2010 12:42:36 -0800 Joe Perches wrote:
> > > Some subsystem maintainers like upper case, some mixed, some lower.
> > > Some aren't consistent.  (Staging/staging)
> > Case usually doesn't matter to most of us.
> Given that we're working in case sensitive languages here it's probably
> safe to assume that a reasonable proportion of people will care; being
> reasonably consistent with existing practice for the subsystem seems
> sensible.

Presumably the tool would also have to traverse up the tree
to find the appropriate style so every MAINTAINERS section
would not need a C entry.

ie: sound/soc/codecs/foo could use the C: entry for sound/soc/

Perhaps something like:
	C:	ASoC basename:

and for arch/x86/:
	C:	x86, dirname:

etc.

