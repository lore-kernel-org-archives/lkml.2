Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422865Ab2JaNXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:23:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58735 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422845Ab2JaNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:23:15 -0400
Message-ID: <50912635.5080009@ti.com>
Date: Wed, 31 Oct 2012 09:23:01 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 03/11] clk: davinci - common clk utilities to init
 clk driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-4-git-send-email-m-karicheri2@ti.com> <CACRpkdZeor=V624OvBek1FccWFvYr2=mPBXZat8ELTtNTTL_rw@mail.gmail.com>
In-Reply-To: <CACRpkdZeor=V624OvBek1FccWFvYr2=mPBXZat8ELTtNTTL_rw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 03:25 PM, Linus Walleij wrote:
> On Thu, Oct 25, 2012 at 6:11 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>
>> This is the common clk driver initialization functions for DaVinci
>> SoCs and other SoCs that uses similar hardware architecture.
>> clock.h also defines struct types for clock definitions in a SoC
>> and clock data type for configuring clk-mux. The initialization
>> functions are used by clock initialization code in a specific
>> platform/SoC.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> This is looking good.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij
>
Linus,

Thanks. I will add your Acked-by in the next revision of the patch.

Murali
