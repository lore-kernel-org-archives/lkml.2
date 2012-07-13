Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab2GMNnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:43:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49889 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2GMNnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:43:43 -0400
Message-ID: <5000260B.8070907@linaro.org>
Date: Fri, 13 Jul 2012 14:43:39 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <4FF6994B.9040801@linaro.org> <20120706173957.GA10202@core.coreip.homeip.net> <4FFB288D.4080606@linaro.org> <20120709201422.GA12242@core.coreip.homeip.net> <4FFB40A4.5060505@linaro.org> <20120709204620.GA12692@core.coreip.homeip.net> <4FFB463F.9040201@linaro.org> <CACRpkdbjkLvD13_g=TvCUYjqhZ7ySOiEL51h9eT3YVMO4Vnr3A@mail.gmail.com> <4FFB4B5F.30103@linaro.org> <CACRpkdYJi3Kk3gpdgFLWr+tun4LZNMw0ET6W2nHJfY5jSvgcjw@mail.gmail.com>
In-Reply-To: <CACRpkdYJi3Kk3gpdgFLWr+tun4LZNMw0ET6W2nHJfY5jSvgcjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/12 22:08, Linus Walleij wrote:
> On Mon, Jul 9, 2012 at 11:21 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> On 09/07/12 23:03, Linus Walleij wrote:
>
>>> Now since I was fooled by the last patch, thinking you had tested it
>>> before
>>> submitting (obviously not) - please send a test log of some
>>> cat /dev/input/event* for this one before I ACK it this time.
>
> (Hm, sorry for grumpy mode...)
>
>> I did test it, but must have only looked at the one IRQ incrementing.
>
> That's not enough, cat /dev/input/event/* whatever event node is used
> by the ponkey, press it and verify you get some garbage (=events)
> in the console.

Yes, garbage seen, works fine.

Also:

> # cat /proc/interrupts
>            CPU0       CPU1
>   6:          0          0    ab8500  ab8500-ponkey-dbf
>   7:          0          0    ab8500  ab8500-ponkey-dbr

Press, release, press, release:

> # cat /proc/interrupts
>            CPU0       CPU1
>   6:          0          2    ab8500  ab8500-ponkey-dbf
>   7:          0          2    ab8500  ab8500-ponkey-dbr

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


