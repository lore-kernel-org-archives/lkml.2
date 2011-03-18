Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab1CRX0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:26:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33641 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752488Ab1CRXZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:25:54 -0400
Date: Fri, 18 Mar 2011 23:25:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: andy.green@linaro.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110318232553.GA11422@opensource.wolfsonmicro.com>
References: <20110311165642.GA9996@kroah.com> <201103181600.09877.arnd@arndb.de> <4D839BCD.6030202@linaro.org> <201103182106.13888.arnd@arndb.de> <4D83CF8C.3020605@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D83CF8C.3020605@linaro.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 09:33:00PM +0000, Andy Green wrote:

> Well: Greg was also reduced to explaining that device renaming in  
> userland was decided "a long time ago".  It's not argumentation, it is  
> an appeal to an alleged tradition.

The story with device renaming is fairly simple - nobody could agree on
what the ideal names should be and different userlands ended up wanting
different things so rather than try to keep everyone happy the kernel
picked the simplest policy possible and let userland override it to its
heart's content.

> You think that striving away to create this Device Tree description of a  
> specific board and maintaining it in a bootloader is LESS work somehow  
> that registering platform devices in an array in the board definition  
> file?  I think not.

It's more the fact that it can be distributed separately to the kernel
which reduces the pressure to mainline the basic board description stuff
for ongoing maintinance.
