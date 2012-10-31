Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422840Ab2JaNWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:22:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34590 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422806Ab2JaNWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:22:20 -0400
Message-ID: <509125FC.1090609@ti.com>
Date: Wed, 31 Oct 2012 09:22:04 -0400
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
Subject: Re: [PATCH v3 04/11] clk: davinci - add pll divider clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-5-git-send-email-m-karicheri2@ti.com> <CACRpkdY3ji_twCqej6Yf8grR7oovf3jeGrbQMzybk5CK5f2Y9A@mail.gmail.com>
In-Reply-To: <CACRpkdY3ji_twCqej6Yf8grR7oovf3jeGrbQMzybk5CK5f2Y9A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 03:26 PM, Linus Walleij wrote:
> On Thu, Oct 25, 2012 at 6:11 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>
>> pll dividers are present in the pll controller of DaVinci and Other
>> SoCs that re-uses the same hardware IP. This has a enable bit for
>> bypass the divider or enable the driver. This is a sub class of the
>> clk-divider clock checks the enable bit to calculare the rate and
>> invoke the recalculate() function of the clk-divider if enabled.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Looking good,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij
>
Linus,

Thanks. I will add your Acked-by in the next version.

Murali
