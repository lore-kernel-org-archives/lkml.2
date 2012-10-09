Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2JIL7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 07:59:25 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33596 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2JIL7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 07:59:23 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.235]
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923BD9B59E3@EXDCVYMBSTM005.EQ1STM.local>
References: <20121001024544.GA12711@localhost> <CAK=WgbakTOS71tvpQDLoANm25Ms_sbz1OcEqBuvO2+ZKwMBsmA@mail.gmail.com>
 <CAK=WgbYK2rFw7iFV1fGUb1saXrsH+yh=2Etmuj5+6ob6cCKntw@mail.gmail.com> <81C3A93C17462B4BBD7E272753C1057923BD9B59E3@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 9 Oct 2012 13:52:49 +0200
Message-ID: <CAK=WgbaNHBVeF_A0jyNpRvnsO_BbkJGxKzyroC6pO1x+OELe0w@mail.gmail.com>
Subject: Re: [remoteproc:for-next 6/9] remoteproc_virtio.c:(.text+0x238e7e):
 undefined reference to `vring_transport_features'
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Tue, Oct 9, 2012 at 12:30 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> Sorry for not responding sooner, but I thought this issue was solved with
> your patch  "remoteproc: fix (again) the virtio-related build breakage"
> (https://lkml.org/lkml/2012/10/6/85).
>
> I'm not sure I understand why you would want to add a dependency to ARM.
> But if you're uncomfortable by having STE_MODEM_RPROC directly selectable,
> perhaps we could let it be selected by arch specific Kconfig files,  e.g. mach-ux500?

I would just like the Kconfig dependencies to reflect the "real world":

E.g., if there's no chance the STE modem is going to be used on x86,
then let's not ask x86 folks about it.

Does limiting the STE modem to certain platform/architectures make
sense ? (if not, that's ok)

Thanks,
Ohad.
