Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab2JKStg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:49:36 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:41872 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756745Ab2JKStd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:49:33 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Date: Thu, 11 Oct 2012 20:49:16 +0200
Subject: RE: [remoteproc:for-next 6/9] remoteproc_virtio.c:(.text+0x238e7e):
 undefined reference to `vring_transport_features'
Thread-Topic: [remoteproc:for-next 6/9]
 remoteproc_virtio.c:(.text+0x238e7e): undefined reference to
 `vring_transport_features'
Thread-Index: Ac2mK8/pQBYwQ2P2TNCrDvDwD7HzmQAKK4Wg
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BDA378AB@EXDCVYMBSTM005.EQ1STM.local>
References: <20121001024544.GA12711@localhost>
 <CAK=WgbakTOS71tvpQDLoANm25Ms_sbz1OcEqBuvO2+ZKwMBsmA@mail.gmail.com>
 <CAK=WgbYK2rFw7iFV1fGUb1saXrsH+yh=2Etmuj5+6ob6cCKntw@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C1057923BD9B59E3@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaNHBVeF_A0jyNpRvnsO_BbkJGxKzyroC6pO1x+OELe0w@mail.gmail.com>
 <20121009132847.GC4587@mwanda>
 <CAK=WgbadhpEaP=ObM8rT=+xnEmh3xzb_ORThDfutH+jDOCf2mQ@mail.gmail.com>
 <20121009142644.GD4587@mwanda>
 <CAK=WgbbV9K-SFbwukDwTAnOBTtwaBUH422Da+CmdvXCN86-aMw@mail.gmail.com>
In-Reply-To: <CAK=WgbbV9K-SFbwukDwTAnOBTtwaBUH422Da+CmdvXCN86-aMw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ohad Ben-Cohen [mailto:ohad@wizery.com] Sent: 9. oktober 2012 16:39
> On Tue, Oct 9, 2012 at 4:26 PM, Dan Carpenter
>
> <dan.carpenter@oracle.com> wrote:
>> If it already compiles fine on x86 then there is no advantage to
>> disabling it.
> 
> Not really; that's really a hardware question and not a software one.
> 
> There are hardware devices that can go with any platform/architecture,
> e.g., WLAN chips. OTOH, there are a lot of hardware devices that are
> coupled with certain SoC, e.g. OMAP's remote processors.
> 
> What I'm trying to understand is whether the STE modem device belongs
> to the former or latter group. It sounds like a modem belongs to the
> former group, but if it does belong to the latter, then the building
> of its driver should be possible only on the relevant
> platforms/architectures.

This driver is intended for NovaThor SoC and for a configuration with
LLI as the shared memory interface between the host and modem.
When using LLI as the shared memory interface the modem could be used
with any platform/architecture with little endian byte sex and a LLI
interface. So I guess this driver belongs in the former group you
mention, and should probably not be dependent on ARM only.

Thanks,
Sjur

