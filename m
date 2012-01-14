Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2ANVZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:25:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51649 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2ANVZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:25:10 -0500
Message-ID: <4F11F271.402@mvista.com>
Date: Sun, 15 Jan 2012 01:24:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
References: <201201120753.00667.oneukum@suse.de> <Pine.LNX.4.44L0.1201121037340.1384-100000@iolanthe.rowland.org> <20120112215014.GC5735@xanatos> <20120112215459.GA1161@kroah.com> <20120112222947.GD5735@xanatos> <20120112223513.GA2925@kroah.com> <20120113061144.GA30569@suse.cz> <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com> <4F1096E9.4020501@mvista.com> <20120113201010.GJ3133@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120113201010.GJ3133@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-01-2012 0:10, Felipe Balbi wrote:

>>> CPPI4.1 (Communication Port Programming Interface) is a TI specific DMA
>>> controller used in multiple TI platform such as AM33x, DA8x, AM35x, TI81x.
>>> The DMA engine is mainly used by musb controller on above platform.

>>     There are (at least out of tree) platforms using CPPI 4.1 for Ethernet.

> if they are out of tree, I'm sorry but we don't care about them. If they
> are in tree, then that needs to be sorted out on the same patchset.

    I'm not sure if Puma-5 is the only one using CPPI 4.1 for Etherhet, and 
not some new platfroms introduced just now like AM33x/TI81x.

>>> It would involve changes in existing musb driver also for which current
>>> plan is to maintain the compatibility of non-CPPI4.1 DMA in musb driver.

>>     I didn't quite understand this part...

> how come ? What he's saying is that while moving cppi-dma.c to

    How come we are taling of cppi-dma.c at all? It's CPPI 3.0 driver having 
nothing in common with CPPI 4.1.

> drivers/dma he will not move all the other dma engines (Inventra, OMAP,
> TUSB-over-GPMC, etc).

>>> The task is planned to be spitted into below subtasks.

>>> (1) Post RFC on the API details, changes envisaged in musb driver and other
>>> challenges

>>     First of all, I foresee changes in drivers/dma/ to cope with the
>> entity in CPPI 4.1 called the queue manager (there's also buffer
>> manager but it wasn't implemented on DA8xx, so I didn't design any
>> API for it).

> that's why the kernel is open source, right ? If we need to improve the
> framework so that it understands other types of DMAs, so be it.

    I just foresee difficulties here.

WBR, Sergei
