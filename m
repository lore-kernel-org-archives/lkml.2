Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0KPXuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:50:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41166 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755793Ab0KPXuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:50:20 -0500
Date: Tue, 16 Nov 2010 23:50:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joe Perches <joe@perches.com>, Florian Mickler <florian@mickler.org>,
        Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
Message-ID: <20101116235025.GA7256@opensource.wolfsonmicro.com>
References: <1289919077.28741.50.camel@Joe-Laptop>
 <20101116183707.179964dd@schatten.dmk.lab>
 <20101116181226.GB26239@rakim.wolfsonmicro.main>
 <20101116203522.65240b18@schatten.dmk.lab>
 <20101116195530.GA7523@rakim.wolfsonmicro.main>
 <20101116122102.86e7e0b9.rdunlap@xenotime.net>
 <1289940156.28741.207.camel@Joe-Laptop>
 <20101116124609.382e42fb.rdunlap@xenotime.net>
 <20101116232258.GC24623@opensource.wolfsonmicro.com>
 <20101116152835.b0ab571c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116152835.b0ab571c.rdunlap@xenotime.net>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 03:28:35PM -0800, Randy Dunlap wrote:
> On Tue, 16 Nov 2010 23:22:58 +0000 Mark Brown wrote:
> > On Tue, Nov 16, 2010 at 12:46:09PM -0800, Randy Dunlap wrote:

> > > Case usually doesn't matter to most of us.

> > Given that we're working in case sensitive languages here it's probably
> > safe to assume that a reasonable proportion of people will care; being
> > reasonably consistent with existing practice for the subsystem seems
> > sensible.

> Greg takes patches that say STAGING or Staging or staging.

> DaveM takes patches that say net: or netdev: or network: or NET:

> The sound maintainers take patches that say sound: or alsa: or ALSA:

> etc.

...and best practice would be to pay attention to what the standard
thing is for the subsystem and follow that.  We shouldn't be suggesting
that people just ignore the case, though obviously if it's not clear
then it's not worth worrying too much about it.
