Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1F0VjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:39:04 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59716 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613Ab1F0Vhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:37:55 -0400
X-Sasl-enc: XQEwnc6+OoJauVdcA0qSif0OIJ+yV49iye/XP5jw3aFu 1309210674
Date: Mon, 27 Jun 2011 14:36:53 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: brcm80211 build busted on big-endian
Message-ID: <20110627213653.GA1489@kroah.com>
References: <20110621.193641.1605224831578508501.davem@davemloft.net>
 <20110622154022.GB19027@kroah.com>
 <20110622.132301.937541188453252019.davem@davemloft.net>
 <20110623112903.1d7f9e9b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623112903.1d7f9e9b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 11:29:03AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Wed, 22 Jun 2011 13:23:01 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> >
> > From: Greg KH <greg@kroah.com>
> > Date: Wed, 22 Jun 2011 08:40:22 -0700
> > 
> > > For big endian, I agree, which is why I thought I fixed this up so it
> > > wouldn't build on other arches than MIPS for the moment.
> > > 
> > > Is this blowing up in -next or in Linus's tree right now?
> > 
> > Yes, on sparc64.
> 
> Yesterday's linux-next allmodconfig build on sparc64:
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/4241857/

Ok, I've hopefully fixed this in the staging-linus branch now, thanks
for your patience.

greg k-h
