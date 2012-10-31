Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935859Ab2JaVRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:17:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:33320 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351Ab2JaVRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:17:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,688,1344236400"; 
   d="scan'208";a="163058694"
Date: Wed, 31 Oct 2012 23:19:57 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Zheng, Lv" <lv.zheng@intel.com>, "Huang, Ying" <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        x86 list <x86@kernel.org>
Subject: Re: [PATCH 1/5] driver core / ACPI: Move ACPI support to core device
 and driver types
Message-ID: <20121031211957.GA16648@intel.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
 <1789657.7GoIl2rp8v@vostro.rjw.lan>
 <3908561D78D1C84285E8C5FCA982C28F19D5B8C0@ORSMSX108.amr.corp.intel.com>
 <4946697.LIFggnbCY6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4946697.LIFggnbCY6@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:06:00PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, October 31, 2012 08:33:53 PM Luck, Tony wrote:
> > > By "tested" I mean "run with some new devices that use the ACPI enumeration
> > > provided here, on x86".  Sorry for being too vague.
> > 
> > Do you or Mika have access to an ia64 box to test.
> 
> I don't.  I'm not sure about Mika.

I also don't have access to any ia64 machine.

As Rafael said, I tested this on x86 machine only.
