Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2JIN3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:29:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31373 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2JIN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:29:17 -0400
Date: Tue, 9 Oct 2012 16:28:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [remoteproc:for-next 6/9] remoteproc_virtio.c:(.text+0x238e7e):
 undefined reference to `vring_transport_features'
Message-ID: <20121009132847.GC4587@mwanda>
References: <20121001024544.GA12711@localhost>
 <CAK=WgbakTOS71tvpQDLoANm25Ms_sbz1OcEqBuvO2+ZKwMBsmA@mail.gmail.com>
 <CAK=WgbYK2rFw7iFV1fGUb1saXrsH+yh=2Etmuj5+6ob6cCKntw@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C1057923BD9B59E3@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaNHBVeF_A0jyNpRvnsO_BbkJGxKzyroC6pO1x+OELe0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbaNHBVeF_A0jyNpRvnsO_BbkJGxKzyroC6pO1x+OELe0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 01:52:49PM +0200, Ohad Ben-Cohen wrote:
> Hi Sjur,
> 
> On Tue, Oct 9, 2012 at 12:30 PM, Sjur BRENDELAND
> <sjur.brandeland@stericsson.com> wrote:
> > Sorry for not responding sooner, but I thought this issue was solved with
> > your patch  "remoteproc: fix (again) the virtio-related build breakage"
> > (https://lkml.org/lkml/2012/10/6/85).
> >
> > I'm not sure I understand why you would want to add a dependency to ARM.
> > But if you're uncomfortable by having STE_MODEM_RPROC directly selectable,
> > perhaps we could let it be selected by arch specific Kconfig files,  e.g. mach-ux500?
> 
> I would just like the Kconfig dependencies to reflect the "real world":
> 
> E.g., if there's no chance the STE modem is going to be used on x86,
> then let's not ask x86 folks about it.
> 
> Does limiting the STE modem to certain platform/architectures make
> sense ? (if not, that's ok)
> 

Unless there is a good reason why then we shouldn't put arbitrary
limits like that.  If we leave it in people at least run static
analyzers on it and try modprobing it.

regards,
dan carpenter

