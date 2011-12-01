Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1LAIWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:22:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36960 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1LAIWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:22:04 -0500
MIME-Version: 1.0
In-Reply-To: <1322727444.2332.12.camel@koala>
References: <1322397903.2799.5.camel@phoenix> <1322727444.2332.12.camel@koala>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Thu, 1 Dec 2011 09:21:22 +0100
Message-ID: <CAOLZvyHmW7joMRbj7OPzmgWVdLr2U0p1P17FdroVmS6skecpAg@mail.gmail.com>
Subject: Re: [PATCH] mtd: convert drivers/mtd/* to use module_platform_driver()
To: dedekind1@gmail.com
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Olof Johansson <olof@lixom.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Vimal Singh <vimal.newwork@gmail.com>,
        Andres Salomon <dilinger@queued.net>, Sukumar Ghorai <s-ghorai@ti.com>,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 9:17 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Sun, 2011-11-27 at 20:45 +0800, Axel Lin wrote:
>> This patch converts the drivers in drivers/mtd/* to use the
>> module_platform_driver() macro which makes the code smaller and a bit
>> simpler.
>
> Pushed to l2-mtd-2.6.git, thanks. However, I got rejects in the
> drivers/mtd/nand/au1550nd.c file, so this part was ignored. Please, take
> a look at this and send an incremental change. Thanks!

Axel's patch is against a bigger change to au1550nd.c (which introduced the
platform driver in the first place) available in linux-next.

Thanks,
        Manuel
