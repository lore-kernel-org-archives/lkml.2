Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946028Ab2JaVm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:42:59 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab2JaVm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:42:57 -0400
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
Date: Wed, 31 Oct 2012 22:46:47 +0100
Message-ID: <1762089.v1Tzu6o6cI@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D5B9DE@ORSMSX108.amr.corp.intel.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <4946697.LIFggnbCY6@vostro.rjw.lan> <3908561D78D1C84285E8C5FCA982C28F19D5B9DE@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 31, 2012 09:36:36 PM Luck, Tony wrote:
> > The BIOSes of currently available ia64 systems don't contain ACPI nodes whose
> > IDs will match the IDs of the new devices (ie. the ones that are going to be
> > added to acpi_platform_device_ids[]), so for ia64 it should be sufficient to
> > test that code as is (ie. without any new devices in the system).
> 
> Ok - built cleanly on ia64.  Boots too. Just one new console message:
> 
> ACPI: bus type platform registered
> 
> that seems pretty harmless.
> 
> Acked-by: Tony Luck <tony.luck@intel.com>

Thanks a lot!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
