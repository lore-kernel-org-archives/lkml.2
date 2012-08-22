Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2HVCW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:22:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61733 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2HVCWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <AAD1C6EB06EE3649B35B7E026785068D1A754366CB@SC-VEXCH2.marvell.com>
References: <AAD1C6EB06EE3649B35B7E026785068D1A754366CB@SC-VEXCH2.marvell.com>
Date: Wed, 22 Aug 2012 10:22:54 +0800
Message-ID: <CADApbehnsRzwu_LrAEMf+L7AvXv+JBtPBOzWHj578Vs6B_LrCw@mail.gmail.com>
Subject: Re: FW: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
From: Chao Xie <xiechao.mail@gmail.com>
To: mturquette@ti.com, haojian.zhuang@gmail.com, mturquette@linaro.org,
        viresh.linux@gmail.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        chao.xie@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, August 20, 2012 1:39 PM
> To: Chao Xie
> Cc: haojian.zhuang@gmail.com; mturquette@linaro.org; viresh.linux@gmail.com; s.hauer@pengutronix.de; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Chao Xie
> Subject: Re: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
>
> On Monday 20 August 2012, Chao Xie wrote:
>>
>> From: Chao Xie <chao.xie@marvell.com>
>>
>> v1->v2:
>> replace __raw_xxx with xxx_relax
>> use ioremap to remap the registers. Finaly it will use device tree to
>> get the physical address.
>> do not use macro to register clocks, and directly call the functions.
>>
>> v2->v3:
>> pxa910 will have APB extension clock, so some peripharals will have
>> clocks in APB extension base.
>> change pxa168-pwm to be pxa910-pwm for pxa910. It will fit the current
>> pwm driver.
>>
>> v3->v4:
>> remove addtional clock name definition
>> replace left __raw_xxx
>>
>> v4->v5:
>> change the format of the file
>>
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
>         Arnd

Who will be responsible for merging these patches?
