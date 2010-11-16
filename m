Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab0KPOvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:51:21 -0500
Received: from mail.perches.com ([173.55.12.10]:1433 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0KPOvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:51:20 -0500
Subject: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101116104921.GL12986@rakim.wolfsonmicro.main>
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
	 <20101116104921.GL12986@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 06:51:17 -0800
Message-ID: <1289919077.28741.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 10:49 +0000, Mark Brown wrote:
> On Mon, Nov 15, 2010 at 11:52:53AM -0800, Joe Perches wrote:
> > On Mon, 2010-11-15 at 19:34 +0000, Mark Brown wrote:
> > > It appears your scripts are already hooked into get_maintainers.pl which
> > > would seem the obvious place to do this?  Sadly I don't do perl, though
> > > it looks like you're doing pretty much all the work on that anyway.
> > Sadly, no it's not the right place.
> To query MAINTAINERS?  I'd assume that's where you'd want to put that
> stuff?

I trimmed cc's and added Andrew Morton and Florian Mickler.
First thread link for them: http://lkml.org/lkml/2010/11/15/262

I use get_maintainer to find email addresses with
"git send-email --cc-cmd=" but sure it could be extended
to find some other new information in the MAINTAINERS file.

Anyway, I think that get_maintainers isn't the proper tool
to rewrite commit subject lines, though it could certainly
do the lookup of a key in the MAINTAINERS file.

Maybe add a new MAINTAINERS section line something like:
	"C:	CommitSubjectGrammarStyle"
where CommitSubjectGrammarStyle is something more
information rich than "style 1", "style 2".

Perhaps you'll propose a grammar to convert path to header
and go through and add these "C:" style entries to the
sections you maintain.

Also, what would you expect the output to be when a single
patch modified files from 2 subsystems that use different
styles?

cheers, Joe

