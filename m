Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0KVTsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:48:36 -0500
Received: from kroah.org ([198.145.64.141]:36535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab0KVTse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:48:34 -0500
Date: Mon, 22 Nov 2010 11:47:36 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc3 problems
Message-ID: <20101122194736.GA29830@kroah.com>
References: <web-407197955@zbackend1.aha.ru>
 <20101122043520.GA10958@kroah.com>
 <20101121205626.4589e544.randy.dunlap@oracle.com>
 <20101121211311.05963007.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121211311.05963007.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 09:13:11PM -0800, Randy Dunlap wrote:
> On Sun, 21 Nov 2010 20:56:26 -0800 Randy Dunlap wrote:
> 
> > On Sun, 21 Nov 2010 20:35:20 -0800 Greg KH wrote:
> > 
> > > On Sun, Nov 21, 2010 at 11:20:40PM -0400, werner wrote:
> > > > 2.6.37-rc3 problems
> > > >
> > > > easycap_main.c lines 4251,4 : implicit declaration lock-kernel   ,  
> > > > unlock_kernel
> > > >
> > > > (compilation error)
> > > 
> > > Either disable this driver from your .config, or enable the BKL in your
> > > .config.  I have a pending patch to get to Linus to fix this Kconfig
> > > issue for this driver.
> > 
> > The build error happens even when CONFIG_BKL=y.  In fact, that's the only
> > way to enable EASYCAP, since EASYCAP depends on BKL.
> 
> OTOH, adding <linux/smp_lock.h> to easycap.h fixes the build.

Ah, nice.  Someone want to send me a patch?  :)

thanks,

greg k-h
