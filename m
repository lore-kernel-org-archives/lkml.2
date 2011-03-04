Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab1CDK3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:29:09 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:56620 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031Ab1CDK3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:29:07 -0500
Message-ID: <4D70BE9D.4000507@stericsson.com>
Date: Fri, 4 Mar 2011 11:27:41 +0100
From: martin persson <martin.persson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Colin Cross <ccross@android.com>,
        "linux-arm-kernel@lists-infradead.org" 
	<linux-arm-kernel@lists-infradead.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Rob Herring <robherring2@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency with cpufreq notifiers
References: <1290060899-9786-1-git-send-email-ccross@android.com> <AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
In-Reply-To: <AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've seen no problems using this patch and have been grateful for it's existence. So I'm happy to put:

Tested-by: martin.persson@stericsson.com

/Martin

On 03/04/2011 11:17 AM, Linus Walleij wrote:
> 2010/11/18 Colin Cross<ccross@android.com>:
>
>> The clock to the ARM TWD local timer scales with the cpu
>> frequency. To allow the cpu frequency to change while
>> maintaining a constant TWD frequency, pick a lower target
>> frequency for the TWD and use the prescaler to divide down
>> to the closest lower frequency.
> We are using this with some custom hooks for the U8500.
>
> Tested-by: Linus Walleij<linus.walleij@linaro.org>
>
> Martin Persson can probably provide an additional Tested-by
> from ST-Ericsson if it helps.
>
> Colin are you merging this patch for 2.6.39 through
> Russells tracker or pull request? It's an important patch
> for us.
>
> Yours,
> Linus Walleij
