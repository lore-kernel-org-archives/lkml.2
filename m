Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab1FAIFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:05:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60009 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933230Ab1FAIFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:05:53 -0400
Date: Wed, 1 Jun 2011 09:05:13 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] mtd: fix physmap.h warnings
Message-ID: <20110601080513.GA21186@flint.arm.linux.org.uk>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523113709.4357b4ba.randy.dunlap@oracle.com> <1306216431.2785.46.camel@localhost> <1306216683.2785.47.camel@localhost> <20110524074020.GA9490@flint.arm.linux.org.uk> <1306222943.2785.55.camel@localhost> <1306914354.4405.49.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306914354.4405.49.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 10:45:54AM +0300, Artem Bityutskiy wrote:
> On Tue, 2011-05-24 at 10:42 +0300, Artem Bityutskiy wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Subject: [PATCH] mtd: fix physmap.h warnings
> > 
> > Fix build warnings in physmap.h:
> > 
> > include/linux/mtd/physmap.h:25: warning: 'struct platform_device' declared inside parameter list
> > include/linux/mtd/physmap.h:25: warning: its scope is only this definition or declaration, which is probably not what you want
> > include/linux/mtd/physmap.h:26: warning: 'struct platform_device' declared inside parameter list
> > include/linux/mtd/physmap.h:27: warning: 'struct platform_device' declared inside parameter list
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> David, it looks like Russel did not merge this patch and people
                            ^^
> complain. Could you please merge it?

Bah, it got lost in the depths of my mailboxes and forgotten...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
