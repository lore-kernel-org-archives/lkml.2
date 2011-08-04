Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1HDVpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:45:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53875 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039Ab1HDVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:45:45 -0400
X-Sasl-enc: Ys6fVbmzWmq8Mw86cIOBLemeYXGhpYBCJwBcpB9NlRQq 1312494344
Date: Thu, 4 Aug 2011 14:44:41 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: Tree for Aug 4 (zcache)
Message-ID: <20110804214441.GA697@kroah.com>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au>
 <20110804142437.34e3a1ae.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804142437.34e3a1ae.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 02:24:37PM -0700, Randy Dunlap wrote:
> On Thu, 4 Aug 2011 14:58:34 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Just in case anyone needs reminding:  Please do not add anything destined
> > for v3.2 into linux-next included trees until after v3.1-rc1.
> 
> 
> on i386:
> 
> drivers/built-in.o: In function `zcache_pampd_create':
> zcache-main.c:(.text+0x159b8f): undefined reference to `__udivdi3'

Very wierd, what would cause that?

greg k-h
