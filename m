Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1LAIR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:17:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46844 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab1LAIR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:17:27 -0500
Subject: Re: [PATCH] mtd: convert drivers/mtd/* to use
 module_platform_driver()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
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
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Vimal Singh <vimal.newwork@gmail.com>,
        Andres Salomon <dilinger@queued.net>, Sukumar Ghorai <s-ghorai@ti.com>,
        linux-mtd@lists.infradead.org
Date: Thu, 01 Dec 2011 10:17:22 +0200
In-Reply-To: <1322397903.2799.5.camel@phoenix>
References: <1322397903.2799.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322727444.2332.12.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 20:45 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/mtd/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

Pushed to l2-mtd-2.6.git, thanks. However, I got rejects in the
drivers/mtd/nand/au1550nd.c file, so this part was ignored. Please, take
a look at this and send an incremental change. Thanks!

Artem.


