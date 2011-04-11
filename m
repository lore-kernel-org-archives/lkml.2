Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1DKVZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:25:18 -0400
Received: from kroah.org ([198.145.64.141]:42052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab1DKVZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:25:16 -0400
Date: Mon, 11 Apr 2011 14:25:13 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
Message-ID: <20110411212513.GA17809@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
 <20110411210631.GA28559@kroah.com>
 <BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:19:13PM +0200, Rafał Miłecki wrote:
> 2011/4/11 Greg KH <greg@kroah.com>:
> > On Mon, Apr 11, 2011 at 11:25:14PM +0200, Rafał Miłecki wrote:
> >> +static void axi_release_core_dev(struct device *dev)
> >> +{
> >> +     /* Silent lack-of-release warning */
> >> +}
> >
> > Ok, WTF!!!!
> 
> Thank you for your kindly words. It's much more enjoyable to work on
> kernel that way. I definitely made that on purpose.

I can't tell if you are kidding or not.

Please read the documentation for how to do this properly.  I find it
really hard to believe that you wrote that comment instead of putting in
the 2 lines of code required for this function.

Especially as-it-is, your code does not work properly and leaks memory
badly.  Why would you do that on purpose?

thanks,

greg k-h
