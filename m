Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1EENs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 09:48:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1EENs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 09:48:27 -0400
Date: Thu, 5 May 2011 15:48:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the trivial tree with the ux500-core
 tree
In-Reply-To: <BANLkTikJ5CVvS+P17T_Mhtqyb29vpDcmvw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105051547000.28291@pobox.suse.cz>
References: <20110429115948.e949234b.sfr@canb.auug.org.au> <BANLkTikJ5CVvS+P17T_Mhtqyb29vpDcmvw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Linus Walleij wrote:

> > Today's linux-next merge of the trivial tree got a conflict in
> > arch/arm/mach-u300/gpio.c between commit 4a5a6e2804a3 ("mach-u300:
> > rewrite gpio driver, move to drivers/gpio") from the ux500-core tree and
> > commit b0c3af5ef0d7 ("arm: mach-u300/gpio: Fix mem_region resource size
> > miscalculations") from the trivial tree.
> >
> > The former removed the file updated by the latter.  These updates should
> > be applied to drivers/gpio/u300-gpio.c, now.  Joe, maybe you could update
> > your patch and send it to Linus Walleij.
> 
> I rewrote the driver completely so likely it will rather be dropped, but
> please check! I'll be happy to carry any patches.

Seems to me that all the calls to request_mem_region() and 
release_mem_region() still need the resource_size() fixup even in the new 
driver.

Either I can carry the current patch in my tree and let Linus resolve the 
conflict, or I can drop it from my tree and you take the fixes through 
your tree. Let me know what you prefer.

-- 
Jiri Kosina
SUSE Labs
