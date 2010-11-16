Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab0KPPEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:04:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35636 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755966Ab0KPPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:04:54 -0500
Date: Tue, 16 Nov 2010 15:04:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: rfc: rewrite commit subject line for subsystem maintainer
 preference tool
Message-ID: <20101116150451.GA26239@rakim.wolfsonmicro.main>
References: <20101115173031.GI12986@rakim.wolfsonmicro.main>
 <1289842444.16461.140.camel@Joe-Laptop>
 <20101115182708.GJ12986@rakim.wolfsonmicro.main>
 <1289845830.16461.149.camel@Joe-Laptop>
 <20101115190738.GF3338@sirena.org.uk>
 <1289848458.16461.150.camel@Joe-Laptop>
 <20101115193407.GK12986@rakim.wolfsonmicro.main>
 <1289850773.16461.166.camel@Joe-Laptop>
 <20101116104921.GL12986@rakim.wolfsonmicro.main>
 <1289919077.28741.50.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289919077.28741.50.camel@Joe-Laptop>
X-Cookie: Onward through the fog.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 06:51:17AM -0800, Joe Perches wrote:

> Maybe add a new MAINTAINERS section line something like:
> 	"C:	CommitSubjectGrammarStyle"
> where CommitSubjectGrammarStyle is something more
> information rich than "style 1", "style 2".

Something printfish would seem reasonable?

> Also, what would you expect the output to be when a single
> patch modified files from 2 subsystems that use different
> styles?

The traditional thing is "ThingX/ThingY: blah" but as with anything else
you need to be sensible.
