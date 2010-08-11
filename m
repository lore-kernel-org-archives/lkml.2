Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0HKB1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:27:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:61249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687Ab0HKB07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:26:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,350,1278313200"; 
   d="scan'208";a="310522685"
From: "Wang, Qi" <qi.wang@intel.com>
To: Greg KH <gregkh@suse.de>, Masayuki Ohtak <masa-korg@dsn.okisemi.com>
CC: "meego-dev@meego.com" <meego-dev@meego.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>
Date: Wed, 11 Aug 2010 09:25:58 +0800
Subject: RE: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Thread-Topic: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Thread-Index: Acs4sYfVmJQIdbhfTJmSloetYo4/owAQfGQw
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A28EA227E@shsmsx501.ccr.corp.intel.com>
References: <4C6131C2.4080101@dsn.okisemi.com>
 <20100810171042.GD21220@suse.de>
In-Reply-To: <20100810171042.GD21220@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7B1RClk031150

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, August 11, 2010 1:11 AM
> To: Masayuki Ohtak
> Cc: meego-dev@meego.com; LKML; Wang, Qi; Wang, Yong Y; Khor, Andrew
> Chih Howe; arjan@linux.intel.com
> Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
> 
> On Tue, Aug 10, 2010 at 08:02:26PM +0900, Masayuki Ohtak wrote:
> > SPI driver of Topcliff PCH
> >
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> > devices connected to SPI.
> >
> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> > ---
> >  drivers/spi/Kconfig                    |   26 +
> >  drivers/spi/Makefile                   |    4 +
> >  drivers/spi/pch_spi.h                  |  177 +++
> >  drivers/spi/pch_spi_main.c             | 1823
> ++++++++++++++++++++++++++++++++
> >  drivers/spi/pch_spi_platform_devices.c |   56 +
> 
> Any reason why you didn't run this by the Linux kernel SPI maintainers
> and developers?  Please use the scripts/get_maintainer.pl script to find
> the proper people if you don't want to look in the MAINTAINERS file to
> find them that way.

Actually OKI submitted this driver to LKML.
We do run './sricpts/get_maintainer.pl -f <directory> to find the maintainer.

Arjan requires all the device drivers to be accepted by Meego kernel should be submitted to Meego-Dev as well for double check.

> 
> thanks,
> 
> greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
