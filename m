Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab2HXHHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:07:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41958 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab2HXHHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1soZxJ87=rL0Mq-3LFRXhqRGrKXcHS+rsMdVeM+yMK+WBCnQ@mail.gmail.com>
References: <AAD1C6EB06EE3649B35B7E026785068D1A754366CB@SC-VEXCH2.marvell.com>
	<CADApbehnsRzwu_LrAEMf+L7AvXv+JBtPBOzWHj578Vs6B_LrCw@mail.gmail.com>
	<201208220641.21891.arnd@arndb.de>
	<CAN1soZxJ87=rL0Mq-3LFRXhqRGrKXcHS+rsMdVeM+yMK+WBCnQ@mail.gmail.com>
Date: Fri, 24 Aug 2012 15:07:19 +0800
Message-ID: <CADApbehj-AFDeJq=ig4AU5u9XGKgOK0imC=qNR9jet9kx3zW2g@mail.gmail.com>
Subject: Re: FW: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
From: Chao Xie <xiechao.mail@gmail.com>
To: mturquette@ti.com, mturquette@linaro.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        chao.xie@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Mike
Can you help to review and merge these patches?

On Wed, Aug 22, 2012 at 4:00 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> On Wed, Aug 22, 2012 at 2:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wednesday 22 August 2012, Chao Xie wrote:
>>> >
>>> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>>> >
>>> >         Arnd
>>>
>>> Who will be responsible for merging these patches?
>>>
>>
>> They should go through Mike's tree, unless there is a reason why he
>> prefers them to go through arm-soc. It would be helpful to add
>> an 'Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>' line
>> and my 'Reviewed-by: Arnd Bergmann <arnd@arndb.de>' line to each
>> patch for that.
>>
>>         Arnd
>
> I'm OK on these patches.
>
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>
> Regards
> Haojian
