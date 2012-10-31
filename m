Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300Ab2JaU0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:26:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab2JaU0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:26:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: [PATCH 1/5] driver core / ACPI: Move ACPI support to core device and driver types
Date: Wed, 31 Oct 2012 21:30:21 +0100
Message-ID: <1789657.7GoIl2rp8v@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D5B845@ORSMSX108.amr.corp.intel.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <5091719D.9090109@zytor.com> <3908561D78D1C84285E8C5FCA982C28F19D5B845@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 31, 2012 08:03:34 PM Luck, Tony wrote:
> On 10/31/2012 11:42 AM, Rafael J. Wysocki wrote:
> > I wonder if the x86 and/or ia64 maintainers have any reservations?
> 
> Can you elaborate on the "tested by mika" that you put into the 0/5
> message. Especially w.r.t. ia64. Compile tested? Boot tested? Ran with
> some new device that uses the ACPI enumeration provided by this series?

By "tested" I mean "run with some new devices that use the ACPI enumeration
provided here, on x86".  Sorry for being too vague.

> Nothing in the concept or code scares me ... but I'd like to know that it
> actually works :-)

Sure.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
