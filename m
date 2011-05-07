Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1EGWnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 18:43:45 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4259 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab1EGWno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 18:43:44 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Sat, 7 May 2011 15:42:25 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Greg KH" <greg@kroah.com>,
        "Michael =?iso-8859-1?Q?B=FCsch?=" <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        "Arend Van Spriel" <arend@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        "Andy Botting" <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
 driver
Message-ID: <20110507224223.GA2537@broadcom.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
 <4DC56FB9.5000208@hauke-m.de>
 <BANLkTi=FfjK7obq0hj4TjYZc-GgzTuUC6g@mail.gmail.com>
 <4DC57425.30206@hauke-m.de>
 <BANLkTikTarvigU-xZNZikhLyvUWse448Tg@mail.gmail.com>
 <4DC5805C.2010202@hauke-m.de>
MIME-Version: 1.0
In-Reply-To: <4DC5805C.2010202@hauke-m.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 61DB147E1IC2762048-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 10:24:44AM -0700, Hauke Mehrtens wrote:
> On 05/07/2011 06:51 PM, Rafał Miłecki wrote:
> > 2011/5/7 Hauke Mehrtens <hauke@hauke-m.de>:
> >> There is a Ethernet core used on embedded devices with this bus and
> >> George wrote a driver for the first version of this bus implementation,
> >> he send to the ML. Most user will use this with some wireless devices so
> >> I would add linux-wireless@vger.kernel.org. Why does ssb uses netdev ML?
> > 
> > Thanks, I didn't know about this ethernet driver. Have to check it!
> > Where was this published? Do you have a thread name?
> 
> I think he haven't send it to the mailing list, there is a link [0] in
> some Ticket [1] at OpenWrt. This driver was derived from source code
> Braodcom have published, but not under a GPL compatible license. It will
> be nice if Braodcom would allow us to publish a driver under the terms
> of the GPL for the Ethernet core based on their driver, without writing
> a full spec of the driver like it was done for b43.

...
> 
> [0] http://www.znau.edu.ua/temp/asus-rt-n16/openwrt-bcm4716-README.txt
> [1] https://dev.openwrt.org/ticket/6580#comment

All of of the patches listed in [0] appear to contain GPL-licensed code.  Can
you provide a pointer to the ethernet driver that you think is not under a
GPL-compatible license?

Thanks,
---
Henry Ptasinski
henryp@broadcom.com

