Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab2JaS4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:56:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49423 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab2JaS4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:56:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        x86 list <x86@kernel.org>
Subject: Re: [PATCH 1/5] driver core / ACPI: Move ACPI support to core device and driver types
Date: Wed, 31 Oct 2012 20:00:46 +0100
Message-ID: <2817799.dxWpAIGCAX@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5091719D.9090109@zytor.com>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan> <1587006.fly6qcnVo1@vostro.rjw.lan> <5091719D.9090109@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 31, 2012 11:44:45 AM H. Peter Anvin wrote:
> On 10/31/2012 11:42 AM, Rafael J. Wysocki wrote:
> >
> > Great, thanks!
> >
> > I wonder if the x86 and/or ia64 maintainers have any reservations?
> >
> 
> None here.
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
