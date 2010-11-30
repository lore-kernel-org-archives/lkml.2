Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab0K3V3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:29:20 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42804 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0K3V3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:29:19 -0500
Date: Tue, 30 Nov 2010 22:29:18 +0100
From: Andreas Mohr <andi@lisas.de>
To: Greg KH <gregkh@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -stable] Add USB PID for new MOSCHIP USB ethernet
 controller MCS7832 variant
Message-ID: <20101130212918.GA20472@rhlx01.hs-esslingen.de>
References: <20101130200737.GA5185@rhlx01.hs-esslingen.de>
 <20101130202712.GB16171@suse.de>
 <20101130210510.GA6057@rhlx01.hs-esslingen.de>
 <20101130211354.GA7635@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130211354.GA7635@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed receivers since it's less relevant]

On Tue, Nov 30, 2010 at 01:13:54PM -0800, Greg KH wrote:
> On Tue, Nov 30, 2010 at 10:05:10PM +0100, Andreas Mohr wrote:
> > From having read that perhaps 2 or 3 times (randomly)
> > and following a couple dozen -stable mails I had the impression that
> > remembering the constraints would be quite easy; obviously not - sorry!
> > Did have some doubts about the number of hunks, though.
> > And obviously violated the "must be upstream" rule.
> > 
> > So what to do?
> 
> Read the line in that file that says:
> 	 - To have the patch automatically included in the stable tree,
> 	   add the tag
> 	        Cc: stable@kernel.org
> 	   in the sign-off area. Once the patch is merged it will be
> 	   applied to the stable tree without anything else needing to
> 	   be done by the author or subsystem maintainer.
> 
> > Shovel patch as-is to networking only (optionally specifying the
> > somewhat unclearly formulated Cc: stable mechanism)?
> > Or rather minimalist-reduce the patch, then dito?
> 
> See above.

Hmm, that doesn't fully answer it.
Anyway, I know what I'll do.

> > > Sometimes I wonder why we even write documentation if no one ever reads
> > > it...
> > 
> > I could also mention some (strangely familiar) cases where people _didn't_
> > write kernel docs which many people likely would have liked to read
> > to avoid wasting half-millions of dollars... *smirk*
> 
> Examples?  And are those people likely to put up the money to write
> those docs?  That's the big problem, people like to complain, but not
> pay anyone to do the work...

I was sheepishly referring to an earlier patch.
Indeed, there's too much complaining and a dearth of activity sometimes.

> thanks,
> 
> greg k-h

Andreas Mohr
