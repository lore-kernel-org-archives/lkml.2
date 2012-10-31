Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab2JaUDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:03:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:10789 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957Ab2JaUDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,688,1344236400"; 
   d="scan'208";a="213654272"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Thread-Index: AQHNt0r0TVxtmXQkpkGhOK26ITzdfZfUDw+AgAAmloCAAAC1gP//n91w
Date: Wed, 31 Oct 2012 20:03:34 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5B845@ORSMSX108.amr.corp.intel.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
 <1825320.jYYkSTpTOm@vostro.rjw.lan> <20121031162407.GA318@kroah.com>
 <1587006.fly6qcnVo1@vostro.rjw.lan> <5091719D.9090109@zytor.com>
In-Reply-To: <5091719D.9090109@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9VK3iY3021479

On 10/31/2012 11:42 AM, Rafael J. Wysocki wrote:
> I wonder if the x86 and/or ia64 maintainers have any reservations?

Can you elaborate on the "tested by mika" that you put into the 0/5
message. Especially w.r.t. ia64. Compile tested? Boot tested? Ran with
some new device that uses the ACPI enumeration provided by this series?

Nothing in the concept or code scares me ... but I'd like to know that it
actually works :-)

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
