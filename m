Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1K0SU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 13:20:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61789 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1K0SU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 13:20:56 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1322397903.2799.5.camel@phoenix>
References: <1322397903.2799.5.camel@phoenix>
Date: Sun, 27 Nov 2011 10:20:55 -0800
Message-ID: <CAOesGMhA0pwfeHEsrAHYZBbpaXFSO-jF-ZUyrVP48wwPbBGj_A@mail.gmail.com>
Subject: Re: [PATCH] mtd: convert drivers/mtd/* to use module_platform_driver()
From: Olof Johansson <olof@lixom.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 4:45 AM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/mtd/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Jiandong Zheng <jdzheng@broadcom.com>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
> Cc: Vimal Singh <vimal.newwork@gmail.com>
> Cc: Andres Salomon <dilinger@queued.net>
> Cc: Sukumar Ghorai <s-ghorai@ti.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Olof Johansson <olof@lixom.net>   (pasemi portions)


-Olof
