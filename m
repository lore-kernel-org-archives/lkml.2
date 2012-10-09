Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2JIOiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:38:55 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34509 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2JIOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:38:52 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.235]
In-Reply-To: <20121009142644.GD4587@mwanda>
References: <20121001024544.GA12711@localhost> <CAK=WgbakTOS71tvpQDLoANm25Ms_sbz1OcEqBuvO2+ZKwMBsmA@mail.gmail.com>
 <CAK=WgbYK2rFw7iFV1fGUb1saXrsH+yh=2Etmuj5+6ob6cCKntw@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C1057923BD9B59E3@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaNHBVeF_A0jyNpRvnsO_BbkJGxKzyroC6pO1x+OELe0w@mail.gmail.com>
 <20121009132847.GC4587@mwanda> <CAK=WgbadhpEaP=ObM8rT=+xnEmh3xzb_ORThDfutH+jDOCf2mQ@mail.gmail.com>
 <20121009142644.GD4587@mwanda>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 9 Oct 2012 16:38:31 +0200
Message-ID: <CAK=WgbbV9K-SFbwukDwTAnOBTtwaBUH422Da+CmdvXCN86-aMw@mail.gmail.com>
Subject: Re: [remoteproc:for-next 6/9] remoteproc_virtio.c:(.text+0x238e7e):
 undefined reference to `vring_transport_features'
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 4:26 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> If it already compiles fine on x86 then there is no advantage to
> disabling it.

Not really; that's really a hardware question and not a software one.

There are hardware devices that can go with any platform/architecture,
e.g., WLAN chips. OTOH, there are a lot of hardware devices that are
coupled with certain SoC, e.g. OMAP's remote processors.

What I'm trying to understand is whether the STE modem device belongs
to the former or latter group. It sounds like a modem belongs to the
former group, but if it does belong to the latter, then the building
of its driver should be possible only on the relevant
platforms/architectures.

Thanks,
Ohad.
