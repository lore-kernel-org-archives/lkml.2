Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682Ab2JaUeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:34:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:6060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036Ab2JaUd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:33:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,688,1344236400"; 
   d="scan'208";a="211915477"
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
Thread-Index: AQHNt0r0TVxtmXQkpkGhOK26ITzdfZfUDw+AgAAmloCAAAC1gP//n91wgAB9pID//4rq8A==
Date: Wed, 31 Oct 2012 20:33:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5B8C0@ORSMSX108.amr.corp.intel.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <5091719D.9090109@zytor.com>
 <3908561D78D1C84285E8C5FCA982C28F19D5B845@ORSMSX108.amr.corp.intel.com>
 <1789657.7GoIl2rp8v@vostro.rjw.lan>
In-Reply-To: <1789657.7GoIl2rp8v@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9VKY4Vn021612

> By "tested" I mean "run with some new devices that use the ACPI enumeration
> provided here, on x86".  Sorry for being too vague.

Do you or Mika have access to an ia64 box to test.  If not, can you suggest
some way that I could exercise this code w/o the new devices. Or at least
reassure myself that all is benign in a system full of old devices.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
