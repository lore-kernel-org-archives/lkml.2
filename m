Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab2B2VSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 16:18:12 -0500
Received: from csmtp3.one.com ([91.198.169.23]:33448 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216Ab2B2VSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 16:18:10 -0500
Date: Wed, 29 Feb 2012 22:19:29 +0100
From: Eric Andersson <eric.andersson@unixphere.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        christoph.mair@gmail.com, stefan.nilsson@unixphere.com,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Message-ID: <20120229211929.GA1254@skinner.xfiles.lan>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
 <201202292018.45557.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202292018.45557.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing!

On 20:18 Wed 29 Feb     , Arnd Bergmann wrote:
> On Wednesday 29 February 2012, Eric Andersson wrote:
> > This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
> > generation of pressure sensors called BMP18x. These pressure sensors can be
> > connected on I2C but also on SPI as a variant, so the driver implements both.
> > Register-wise they are fully compatible with the older BMP085, so the driver will
> > support those chips as well.
> > 
> > The driver is based on bmp085.c by Christoph Mair.
> 
> Hmm,  the implementation looks fine, but I don't think we should add support
> for new devices with a one-off interface that we know is getting replaced by
> something generic.
> 
> Why is this not using IIO for its user interface?

I was unsure about the state of iio since it recides in staging. When
can one expect it to move out of there? Has it been accepted as the
replacement for input/misc and drivers/misc sensors?

I agree that this is maybe not a long-term solution, but this is what we
have right now. Maybe not the best argument, but this can be seen as an improvement
to the bmp085 driver so "the damage has already been done".

-- 
Best regards,
 Eric

http://www.unixphere.com
