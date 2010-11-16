Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0KPUqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:46:17 -0500
Received: from xenotime.net ([72.52.115.56]:42689 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755910Ab0KPUqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:46:15 -0500
Date: Tue, 16 Nov 2010 12:46:09 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Florian Mickler <florian@mickler.org>,
        Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
Message-Id: <20101116124609.382e42fb.rdunlap@xenotime.net>
In-Reply-To: <1289940156.28741.207.camel@Joe-Laptop>
References: <1289845830.16461.149.camel@Joe-Laptop>
	<20101115190738.GF3338@sirena.org.uk>
	<1289848458.16461.150.camel@Joe-Laptop>
	<20101115193407.GK12986@rakim.wolfsonmicro.main>
	<1289850773.16461.166.camel@Joe-Laptop>
	<20101116104921.GL12986@rakim.wolfsonmicro.main>
	<1289919077.28741.50.camel@Joe-Laptop>
	<20101116183707.179964dd@schatten.dmk.lab>
	<20101116181226.GB26239@rakim.wolfsonmicro.main>
	<20101116203522.65240b18@schatten.dmk.lab>
	<20101116195530.GA7523@rakim.wolfsonmicro.main>
	<20101116122102.86e7e0b9.rdunlap@xenotime.net>
	<1289940156.28741.207.camel@Joe-Laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 12:42:36 -0800 Joe Perches wrote:

> On Tue, 2010-11-16 at 12:21 -0800, Randy Dunlap wrote:
> > On Tue, 16 Nov 2010 19:55:31 +0000 Mark Brown wrote:
> > I don't know what you asked Joe to change, but asking someone to use
> > the documented canonical patch format:
> > <quote>
> > The canonical patch subject line is:
> >     Subject: [PATCH 001/123] subsystem: summary phrase
> > </quote>
> > should be fine.  And there is no need for printf-ish templates
> > for this in MAINTAINERS either.
> 
> I've never read that before.  Learn something new etc...
> It seems path prefixes aren't good nor even commonly used.
> 
> A review of kernel patch subjects:
> 
> $ git log --no-merges --pretty=oneline | \
> 	cut -f2- -d" " | cut -f1 -d: | sort | uniq -c | sort -rn
> 
> is interesting.  Here's the head:
>    5007 x86
>    3943 Staging
>    3220 USB
>    2790 sh
>    2707 KVM
>    2624 ARM
>    2449 ALSA
>    1571 Input
>    1549 ASoC
>    1470 iwlwifi
>    1423 ACPI
>    1397 mac80211
>    1384 V4L/DVB
>    1226 sched
>    1200 Btrfs
>    1184 powerpc
>    1106 [NETFILTER]
>    1080 MIPS
>    1049 net
>    1047 ide
>    1014 drm/i915
>     993 staging
>     921 ath9k

$ARCH is a commonly accepted substitute for subsystem.

And yes, lots of people use <drivername> there as well.


> Some subsystem maintainers like upper case, some mixed, some lower.
> Some aren't consistent.  (Staging/staging)

Case usually doesn't matter to most of us.

> It doesn't seem a rule can be pregenerated so maybe adding these
> "C:" lines to MAINTAINERS has some value.

Hopefully it won't go that far.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
