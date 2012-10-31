Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935924Ab2JaVgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:36:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:43964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903Ab2JaVgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:36:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,688,1344236400"; 
   d="scan'208";a="211939610"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Zheng, Lv" <lv.zheng@intel.com>, "Huang, Ying" <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        x86 list <x86@kernel.org>
Subject: RE: [PATCH 1/5] driver core / ACPI: Move ACPI support to core
 device and driver types
Thread-Topic: [PATCH 1/5] driver core / ACPI: Move ACPI support to core
 device and driver types
Thread-Index: AQHNt0r0TVxtmXQkpkGhOK26ITzdfZfUDw+AgAAmloCAAAC1gP//n91wgAB9pID//4rq8IAAfwwA//+SjzA=
Date: Wed, 31 Oct 2012 21:36:36 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5B9DE@ORSMSX108.amr.corp.intel.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
 <1789657.7GoIl2rp8v@vostro.rjw.lan>
 <3908561D78D1C84285E8C5FCA982C28F19D5B8C0@ORSMSX108.amr.corp.intel.com>
 <4946697.LIFggnbCY6@vostro.rjw.lan>
In-Reply-To: <4946697.LIFggnbCY6@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9VLalAR021782

> The BIOSes of currently available ia64 systems don't contain ACPI nodes whose
> IDs will match the IDs of the new devices (ie. the ones that are going to be
> added to acpi_platform_device_ids[]), so for ia64 it should be sufficient to
> test that code as is (ie. without any new devices in the system).

Ok - built cleanly on ia64.  Boots too. Just one new console message:

ACPI: bus type platform registered

that seems pretty harmless.

Acked-by: Tony Luck <tony.luck@intel.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
