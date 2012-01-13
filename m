Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab2AMTmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:42:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34459 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab2AMTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:42:21 -0500
Message-ID: <4F1096E9.4020501@mvista.com>
Date: Fri, 13 Jan 2012 23:41:13 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
References: <201201120753.00667.oneukum@suse.de> <Pine.LNX.4.44L0.1201121037340.1384-100000@iolanthe.rowland.org> <20120112215014.GC5735@xanatos> <20120112215459.GA1161@kroah.com> <20120112222947.GD5735@xanatos> <20120112223513.GA2925@kroah.com> <20120113061144.GA30569@suse.cz> <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com>
In-Reply-To: <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/13/2012 01:40 PM, Gupta, Ajay Kumar wrote:

> CPPI4.1 (Communication Port Programming Interface) is a TI specific DMA
> controller used in multiple TI platform such as AM33x, DA8x, AM35x, TI81x.
> The DMA engine is mainly used by musb controller on above platform.

    There are (at least out of tree) platforms using CPPI 4.1 for Ethernet.

> Earlier version of the driver was submitted by Sergei Shtylyov at [1] but
> was not merged due to disagreement on the location of driver in kernel.

    To be precise, TI requested pulling out already queued (to arch/arm/common/) 
CPPI 4.1 driver from RMK's patch system without even notifying me. At least that 
was RMK's version...

> Refer the discussions at [1] for more details.

> [1] http://marc.info/?l=linux-usb&m=125087318308323

    Unfortunately, that's not all of the discussion of interest.

> The new implementation of the CPPI4.1 DMA slave driver will be in the
> drivers/dma folder, complying to dmaengine framework.

    Has there been any work in this direction done yet?

> It would involve changes in existing musb driver also for which current
> plan is to maintain the compatibility of non-CPPI4.1 DMA in musb driver.

    I didn't quite understand this part...

> The task is planned to be spitted into below subtasks.

> (1) Post RFC on the API details, changes envisaged in musb driver and other
> challenges

    First of all, I foresee changes in drivers/dma/ to cope with the entity in 
CPPI 4.1 called the queue manager (there's also buffer manager but it wasn't 
implemented on DA8xx, so I didn't design any API for it).

> (2) Implement and post RFC for the CPPI4.1 DMA driver and changes needed in
> musb driver.

> Let me know if you have any thoughts/comments on this.

> Regards,
> Ajay

WBR, Sergei

