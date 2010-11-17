Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab0KQA4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:56:01 -0500
Received: from xenotime.net ([72.52.115.56]:57859 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932265Ab0KQA4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:56:00 -0500
Date: Tue, 16 Nov 2010 16:55:56 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Florian Mickler <florian@mickler.org>,
        Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
Message-Id: <20101116165556.3ee8e236.rdunlap@xenotime.net>
In-Reply-To: <1289951875.28741.261.camel@Joe-Laptop>
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
	<20101116152835.b0ab571c.rdunlap@xenotime.net>
	<1289951875.28741.261.camel@Joe-Laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 15:57:55 -0800 Joe Perches wrote:

> On Tue, 2010-11-16 at 15:28 -0800, Randy Dunlap wrote:
> > On Tue, 16 Nov 2010 23:22:58 +0000 Mark Brown wrote:
> > > On Tue, Nov 16, 2010 at 12:46:09PM -0800, Randy Dunlap wrote:
> > > > On Tue, 16 Nov 2010 12:42:36 -0800 Joe Perches wrote:
> > > > > Some subsystem maintainers like upper case, some mixed, some lower.
> > > > > Some aren't consistent.  (Staging/staging)
> > > > Case usually doesn't matter to most of us.
> > > Given that we're working in case sensitive languages here it's probably
> > > safe to assume that a reasonable proportion of people will care; being
> > > reasonably consistent with existing practice for the subsystem seems
> > > sensible.
> > Greg takes patches that say STAGING or Staging or staging.
> 
> Greg seems to rewrite patch subjects and is inconsistent
> about case, so he might be doing that by hand.
> 
> > DaveM takes patches that say net: or netdev: or network: or NET:
> 
> DaveM doesn't appear to be choosy about patch subject lines.
> He seems to take any sensible patch and as far as I know he
> doesn't edit the subject lines.  He does reject inferior
> patches outright.
> 
> > The sound maintainers take patches that say sound: or alsa: or ALSA:
> 
> The sound maintainers seem to rewrite patch subjects on an
> ad-hoc basis.

OK, I can accept your summary.
However, I can't tell that we are making any progress.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
