Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2LASQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:16:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62949 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2LASP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:15:59 -0500
Message-ID: <50BA495B.3010008@gmail.com>
Date: Sat, 01 Dec 2012 19:15:55 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: Dove: Add pinctrl clock to DT
References: <20121125152845.GV15800@titan.lakedaemon.net> <1353921525-25163-1-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkdZcHsvSG-vfynd0jYrs0kVYqPsgtroSrQdz4yDZexQZjA@mail.gmail.com> <20121201181313.GF12509@titan.lakedaemon.net>
In-Reply-To: <20121201181313.GF12509@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2012 07:13 PM, Jason Cooper wrote:
> On Sat, Dec 01, 2012 at 06:07:06PM +0100, Linus Walleij wrote:
>> On Mon, Nov 26, 2012 at 10:18 AM, Sebastian Hesselbarth
>> <sebastian.hesselbarth@gmail.com>  wrote:
>>
>>> During merge of the mvebu patches a clock gate for pinctrl was
>>> lost. This patch just readds the clock gate.
>>>
>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>
>> Acked-by: Linus Walleij<linus.walleij@linaro.org>
>>
>> So who's supposed to merge this patch? Me? The MVEBU-maintainer?
>
> I'll take it and merge it in once v3.8-rc1 drops.

Linus, Jason,

I agree to take it through Jason's tree but please take v2 of
the patch as there has been a small change in one of the patches.

Sebastian
