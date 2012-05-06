Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2EFHZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 03:25:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58222 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2EFHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 03:25:50 -0400
Message-ID: <4FA62777.4030402@linaro.org>
Date: Sun, 06 May 2012 08:25:43 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com> <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com> <4F9C1CF5.3050706@linaro.org> <20120505120835.GA26976@lizard> <CAF2Aj3hy3KOsH3aiZ0UpuERSwOoqFdYQ4su-hEVcU-qp8r5d9A@mail.gmail.com> <20120505215542.GA16010@lizard>
In-Reply-To: <20120505215542.GA16010@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/12 22:55, Anton Vorontsov wrote:
> On Sat, May 05, 2012 at 05:55:09PM +0100, Lee Jones wrote:
>> Do you have a public tree/branch that I can look at so I may see the entire
>> file please?
>
> Yep, here is the gitweb:
> 	http://git.infradead.org/battery-2.6.git
> or
> 	git clone git://git.infradead.org/battery-2.6.git

Patches look good.

Better as 3 separate commits in case of any potential revert, but for 
the code:

   Signed-off-by: Lee Jones <lee.jones@linaro.org>

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
