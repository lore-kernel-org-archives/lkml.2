Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2JEGmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:42:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43389 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2JEGmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:42:08 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH v2 0/7] uio_pruss cleanup and platform support
Thread-Topic: [PATCH v2 0/7] uio_pruss cleanup and platform support
Thread-Index: AQHNnbDBq0mAo1oeIk+/mQ19uCF7cpenWDUAgALNG/A=
Date: Fri, 5 Oct 2012 04:43:56 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA9C6B7@DBDE01.ent.ti.com>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
 <20121003150058.GB11180@beef>
In-Reply-To: <20121003150058.GB11180@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Wed, Oct 03, 2012 at 20:30:58, Porter, Matt wrote:
> On Fri, Sep 28, 2012 at 03:37:45PM -0400, Matt Porter wrote:
> > Changes since v1:
> > 	- Replaced uio_pruss private SRAM API use with genalloc
> > 	- Added DA850 platform device and clock support
> > 	- Added DA850 L3 RAM gen_pool support
> > 	- Split out DT binding
> > 
> > This series enables uio_pruss on both DA850 and AM33xx. The driver
> > previously was not enabled by any platform and the private SRAM API
> > was accessing an invalid SRAM bank for use on DA850. For AM33xx,
> > DT, pinctrl, and runtime PM support are added since AM33xx only
> > boots via DT.
> 
> I'm dropping AM33xx/OMAP support from v3 for this series 

Just for my clarification, I believe you will be taking up AM33xx/OMAP 
SRAM support later once you have completed supporting DaVinci. Right?

> since the
> focus has turned to fixing Davinci SRAM to provide genalloc support
> and the associated use of that in the driver.
> 
> I'll have a separate series with AM33xx support since dealing cleanly
> with external resets on OMAP is a bigger issue.
> 
> -Matt
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
