Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2KFQFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:05:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33146 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab2KFQFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:05:06 -0500
Message-ID: <50993511.3020906@ti.com>
Date: Tue, 6 Nov 2012 11:04:33 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Rob Herring <robherring2@gmail.com>, <dwmw2@infradead.org>,
        <artem.bityutskiy@linux.intel.com>, <b32955@freescale.com>,
        <shubhrajyoti@ti.com>, <wim@iguana.be>, <hs@denx.de>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>,
        <hdoyu@nvidia.com>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFC PATCH 1/2] memory: davinci - add aemif controller platform
 driver
References: <1351873278-27325-1-git-send-email-m-karicheri2@ti.com> <1351873278-27325-2-git-send-email-m-karicheri2@ti.com> <50967307.5030500@gmail.com> <50982AC3.8030000@ti.com> <5098BFE1.3020906@ti.com>
In-Reply-To: <5098BFE1.3020906@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 02:44 AM, Sekhar Nori wrote:
> On 11/6/2012 2:38 AM, Murali Karicheri wrote:
>> On 11/04/2012 08:52 AM, Rob Herring wrote:
>>> OMAP GPMC
>> Could you send me a link please?
> https://www.google.com/search?q=RFC+OMAP+GPMC+DT+bindings
>
> The patches series is sent by Daniel Mack. v3 was the last version sent.
>
> Thanks,
> Sekhar
>
>
One of the question I have on this is what is the final location of the 
GPMC driver? The patch referred here is located inside the mach-omap2. 
This will not work for us as AEMIF driver is used across multiple 
architecture. range is also used in AEMIF bindings to refer the CS 
memory map. So there is no issue here. I will fix the documentation. Or 
Am I missing something?

Murali
