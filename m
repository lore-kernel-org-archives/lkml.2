Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0H0Syl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:54:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:41535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab0H0Syj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:54:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,279,1280732400"; 
   d="scan'208";a="601127965"
Message-ID: <4C7809ED.9070506@linux.intel.com>
Date: Fri, 27 Aug 2010 11:54:37 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Masayuki Ohtak <masa-korg@dsn.okisemi.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com> <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2010 11:53 AM, Thomas Gleixner wrote:
> B1;2401;0cOn Fri, 27 Aug 2010, Grant Likely wrote:
>    
>> [cc'ing Thomas Gleixner and David Woodhouse since this driver needs to
>> get some data about the platform (to know what spi_devices are
>> present) and I don't know how that is handled for x86 SoCs.]
>>      
> The best way to do all this platform specific configuration is to use
> device tree. I really don't want to have x86/mach-xyz/board[A-Z]
> horror, which is unavoidable when we don't get a sensible way to
> configure the boards. SFI was meant to provide a lightweight ACPI, but
> now that device tree is generic and more platforms are using it, I
> really want to standartize on that and forget SFI.
>
> That makes even more sense, as all these AMBA peripherals which are
> duct-taped to a x86 core can be found in other SoCs with different
> cores as well.
>    

I tentatively agree, but this has to coexist with ACPI, which most of 
these platforms will also have,
for power management if nothing else.

