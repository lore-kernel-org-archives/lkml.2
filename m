Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2IMHC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:02:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35606 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2IMHC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:02:27 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Dooks <ben-linux@fluff.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 02/16] ARM: davinci: move platform_data definitions
Thread-Topic: [PATCH 02/16] ARM: davinci: move platform_data definitions
Thread-Index: AQHNkB2hDdV0QnjnwEunK47bS7LbDpeGhaVggAARIICAAUPoUA==
Date: Thu, 13 Sep 2012 07:00:54 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA811E3@DBDE01.ent.ti.com>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-2-git-send-email-arnd@arndb.de>
 <1BAFE6F6C881BF42822005164F1491C33EA802EC@DBDE01.ent.ti.com>
 <201209121711.10715.arnd@arndb.de>
In-Reply-To: <201209121711.10715.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 22:41:09, Arnd Bergmann wrote:
> On Wednesday 12 September 2012, Hebbar, Gururaja wrote:
> > On Tue, Sep 11, 2012 at 18:29:36, Arnd Bergmann wrote:
> 
> > >  drivers/usb/musb/da8xx.c                                     |    2 +-
> > 
> > 
> > >  .../asp.h => include/linux/platform_data/asoc-davinci-evm.h  |    0
> > 
> > 
> > This will clash with patch "ASoC/ARM: Davinci: McASP: split asp header into 
> > platform and audio specific" queued in ASoC tree by Mark
> > 
> 
> Ok, I've taken out that hunk, this is the remaining patch. There will
> still be minor conflicts though, because it changes some adjacent lines.
> 
> 	Arnd

Thanks for the consideration.

> 
> 
..snip..
..snip..


Regards, 
Gururaja
