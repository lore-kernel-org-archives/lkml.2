Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab2ADCUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:20:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40716 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2ADCUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:20:42 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbvta3chYeMS=J94ehaOcEXp1OBnU74qSSCAO--PbehLg@mail.gmail.com>
References: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
	<1324541855-19911-2-git-send-email-haojian.zhuang@marvell.com>
	<CACRpkdbvta3chYeMS=J94ehaOcEXp1OBnU74qSSCAO--PbehLg@mail.gmail.com>
Date: Wed, 4 Jan 2012 10:20:41 +0800
Message-ID: <CAN1soZwhd=1bsKumvYg0hw9m-kRNb6Mio7GzOFk-d3dZZ-+pXA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pinctrl: enable pinmux for mmp series
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 1, 2012 at 10:15 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Dec 22, 2011 at 9:17 AM, Haojian Zhuang
> <haojian.zhuang@marvell.com> wrote:
>
>> Support PXA168/PXA910/MMP2 pinmux. Now only support function switch.
>
> (...)
>
>> +config PINCTRL_PXA3xx
>> +       bool
>> +       select PINMUX
>> +
>
> Good,
>
>> +config PINMUX_MMP2
>> +       bool "MMP2 pinmux driver"
>> +       depends on ARCH_MMP
>> +       select PINCTRL_PXA3xx
>> +       select PINCONF
>> +
>> +config PINMUX_PXA168
>> +       bool "PXA168 pinmux driver"
>> +       depends on ARCH_MMP
>> +       select PINCTRL_PXA3xx
>> +       select PINCONF
>> +
>> +config PINMUX_PXA910
>> +       bool "PXA910 pinmux driver"
>> +       depends on ARCH_MMP
>> +       select PINCTRL_PXA3xx
>> +       select PINCONF
>> +
>
> Please rename these PINCTRL_* too.
>

Changed file according to all comments in another patch series.

Thanks
Haojian
