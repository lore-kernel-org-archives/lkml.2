Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2KPOLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:11:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63168 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2KPOLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:11:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121116140912.GB20006@beef>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
 <1350570453-24546-5-git-send-email-p.zabel@pengutronix.de>
 <20121114191551.5E8673E0B7C@localhost> <1352985095.2399.184.camel@pizza.hi.pengutronix.de>
 <20121116140912.GB20006@beef>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 16 Nov 2012 14:11:25 +0000
X-Google-Sender-Auth: ksn8_87sLOxtmPHpCW0bb4i6tGg
Message-ID: <CACxGe6tEeG6kVBMDbDi3h5hO4PcuO0EfA6q-_5tKB3ipCr+O3g@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] misc: sram: add support for configurable
 allocation order
To: Matt Porter <mporter@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 2:09 PM, Matt Porter <mporter@ti.com> wrote:
> On Thu, Nov 15, 2012 at 02:11:35PM +0100, Philipp Zabel wrote:
>> Am Mittwoch, den 14.11.2012, 19:15 +0000 schrieb Grant Likely:
>> > Assuming it is appropriate to put into the device tree, I'd suggest a
>> > different name. Instead of 'order', how about 'sram-alloc-align' (in
>> > address bits) or 'sram-alloc-min-size' (in bytes).
>>
>> A size in bytes would be the most obvious to me, although that allows to
>> enter values that are not a power of two.
>
> I think the implication is that this isn't even a h/w characteristic of
> SRAM and, as such, does not belong in a DT binding (for that reason I
> don't mind seeing that it's been dropped in v6). It's unfortunate since
> it's otherwise a very clean solution. I sure wish I had a "Software
> Tree" I could pass in too. ;)

It is however in that grey area where which it isn't really a
characteristic of the hardware it has a very strong implied usage. I
do push back on things like this not because they shouldn't be done,
but rather to make sure it is properly thought through before going
ahead.

g.
