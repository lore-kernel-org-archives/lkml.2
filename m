Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966243Ab2CANUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:20:32 -0500
Received: from csmtp2.one.com ([91.198.169.22]:6704 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966168Ab2CANTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:19:54 -0500
Date: Thu, 1 Mar 2012 14:19:27 +0100
From: Eric Andersson <eric.andersson@unixphere.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, christoph.mair@gmail.com,
        stefan.nilsson@unixphere.com, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Message-ID: <20120301131927.GB15377@scully.xfiles.lan>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
 <201202292018.45557.arnd@arndb.de>
 <20120229203743.GA21671@elliptictech.com>
 <201202292126.56083.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202292126.56083.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:26 Wed 29 Feb     , Arnd Bergmann wrote:
> On Wednesday 29 February 2012, Nick Bowler wrote:
> > On 2012-02-29 20:18 +0000, Arnd Bergmann wrote:
> > > On Wednesday 29 February 2012, Eric Andersson wrote:
> > > > This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
> > > > generation of pressure sensors called BMP18x. These pressure sensors can be
> > > > connected on I2C but also on SPI as a variant, so the driver implements both.
> > > > Register-wise they are fully compatible with the older BMP085, so the driver will
> > > > support those chips as well.
> > > > 
> > > > The driver is based on bmp085.c by Christoph Mair.
> > > 
> > > Hmm,  the implementation looks fine, but I don't think we should add support
> > > for new devices with a one-off interface that we know is getting replaced by
> > > something generic.
> > 
> > Notwithstanding the value of using newer generic interfaces, from what I
> > can tell, there are no new sysfs attributes added by this driver over
> > the one it replaces.  If this driver is going to supersede the old one,
> > it has to retain the existing interface.  Otherwise, we must keep both
> > drivers in the tree to avoid regressions.
> 
> Well, the driver is presented as a new one ;-)
> 
> I also think it would be nicer generally speaking to do this as incremental
> updates, which could be as simple as
> 
> 1. code cleanups in bmp085 without functional changes
> 2. add support for bmp18x
> 3. rename bmp085 to bmp18x, with no other changes

Fair enough! I will create a new patch-set that is more incremental.

-- 
Best regards,
 Eric

 http://www.unixphere.com
