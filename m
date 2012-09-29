Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311Ab2I2NiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:38:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:50245 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030199Ab2I2Nh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,507,1344236400"; 
   d="scan'208";a="198722925"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: RE: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
 driver
Thread-Topic: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller
 enumeration driver
Thread-Index: AQHNnUx4YaROkQfVYU+gelfZPaq2VZefL/SAgAIjU8A=
Date: Sat, 29 Sep 2012 13:37:53 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926322C16F@SHSMSX101.ccr.corp.intel.com>
References: <1348818032.10877.325.camel@rui.sh.intel.com>
 <20120928135401.6781d134@pyramind.ukuu.org.uk>
In-Reply-To: <20120928135401.6781d134@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8TDc6J0019731



> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Friday, September 28, 2012 8:54 PM
> To: Zhang, Rui
> Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> Subject: Re: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller
> enumeration driver
> Importance: High
> 
> On Fri, 28 Sep 2012 15:40:32 +0800
> Zhang Rui <rui.zhang@intel.com> wrote:
> 
> > >From 6077a62f2865201ab6727ca7d628ee5e43aa57e1 Mon Sep 17 00:00:00
> > >2001
> > From: Zhang Rui <rui.zhang@intel.com>
> > Date: Fri, 24 Aug 2012 15:18:25 +0800
> > Subject: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller
> > enumeration  driver
> >
> > This driver is able to
> > 1) enumerate I2C controller via ACPI namespace
> >    and register it as a platform device.
> > 2) enumerate I2C slave devices via ACPI namespace.
> 
> Will this also trigger and work with the ACPI4 based devices that seem
> to have IÂ²C tables that Linux currently doesn't understand (eq some
> GMA600/Oaktrail platforms) ?

I'm not aware of this. I think the answer is probably "No"
because these PNPids are pretty new.
But we can check FADT.revision to make the driver work
on ACPI5 platforms only.

Thanks,
rui

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
