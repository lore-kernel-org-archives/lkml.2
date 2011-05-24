Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1EXHlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:41:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59207 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1EXHlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:41:04 -0400
Date: Tue, 24 May 2011 08:40:20 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] mtd: fix physmap.h warnings
Message-ID: <20110524074020.GA9490@flint.arm.linux.org.uk>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523113709.4357b4ba.randy.dunlap@oracle.com> <1306216431.2785.46.camel@localhost> <1306216683.2785.47.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306216683.2785.47.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 08:58:03AM +0300, Artem Bityutskiy wrote:
> On Tue, 2011-05-24 at 08:53 +0300, Artem Bityutskiy wrote:
> > On Mon, 2011-05-23 at 11:37 -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Fix build warnings in physmap.h:
> > > 
> > > include/linux/mtd/physmap.h:25: warning: 'struct platform_device' declared inside parameter list
> > > include/linux/mtd/physmap.h:25: warning: its scope is only this definition or declaration, which is probably not what you want
> > > include/linux/mtd/physmap.h:26: warning: 'struct platform_device' declared inside parameter list
> > > include/linux/mtd/physmap.h:27: warning: 'struct platform_device' declared inside parameter list
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Oh, this was missed during review.  This was introduced in
> > b7281ca2a4b00044c60c25059f467d05772cdbe3 which is going in via Russel's
> > tree, so I guess Russel could pick up your patch.
> 
> My big apologies, s/Russel/Russell/.

Which patch?  Neither of these messages contained Randy's patch and I
wasn't included on the original posting.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
