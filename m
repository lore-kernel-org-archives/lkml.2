Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab0KQN3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:29:52 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:60263 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932615Ab0KQN3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:29:49 -0500
Date: Wed, 17 Nov 2010 15:28:44 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
Message-ID: <20101117132844.GE26928@jasper.tkos.co.il>
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
 <4CE373BC.30805@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE373BC.30805@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Nov 17, 2010 at 02:18:36PM +0800, Thomas Chou wrote:
> On 11/15/2010 04:23 PM, Baruch Siach wrote:
> >From: Alex Gershgorin<agersh@rambler.ru>
> >
> >The active serial protocol can be used to program Altera serial configuration
> >devices. This driver uses the kernel gpio interface to implement the active
> >serial protocol.
> >
> >This patch also introduces the include/platform_drivers/ directory, which is
> >the new home for platform data headers. This is per Greg's suggestion.
> 
> Altera EPCS is normal SPI serial flash, which is exactly the same as
> STmicro part. Please consider existing drivers/mtd/devices/m25p80.c
> and drivers/spi/spi_gpio.c.

Thanks for the pointer. Looking at the op codes and status bits it seems you 
are right. The 38 pages Altera datasheet doesn't mention the terms SPI or 
m25p80. Go figure.

I'll test you suggestion.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
