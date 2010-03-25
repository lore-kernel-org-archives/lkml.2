Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0CYPNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:13:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:36906 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab0CYPNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,307,1267430400"; 
   d="scan'208";a="552054102"
Message-ID: <4BAB7D9F.4070807@intel.com>
Date: Thu, 25 Mar 2010 08:13:35 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: jassi brar <jassisinghbrar@gmail.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
References: <4BAAD5BB.7050101@samsung.com>	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com> <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
In-Reply-To: <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jassi brar wrote:
>> Perhaps Joonyoung can simply port over the stuff
>> you need to this driver if you show your code.
> Having worked on Samsung SoCs(with PL330 DMAC) based products, I would be
> _very_ surprised if any user found this implementation useful.
> Let alone testing, this implementation can't even explain usability
> for fast peripherals
> with shallow FIFOs. I didn't give feedback for this patch because I am
> not sure if this
> is the right way to go at all.

This is the wrong attitude.  If it were not for a simple oversight 
Joonyoung's driver would already be upstream for the past two kernel 
releases.  So you need to work together to improve that driver to 
incorporate what you need.

It sounds like you just need to add an extension for the arch specific 
dma api.  At first glance this can mimic the approach taken by 
Nobuhiro-san with the shdma driver.

--
Dan

