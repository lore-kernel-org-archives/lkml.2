Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285Ab2KWIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:06:13 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44209 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030213Ab2KWIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:06:12 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdatVyDcTQnJ_qeZwckxJeApZBgw=_ivz98DJhNWjYFheA@mail.gmail.com>
References: <1353409479-3304-1-git-send-email-sachin.kamat@linaro.org>
	<CACRpkdatVyDcTQnJ_qeZwckxJeApZBgw=_ivz98DJhNWjYFheA@mail.gmail.com>
Date: Fri, 23 Nov 2012 13:36:11 +0530
Message-ID: <CAK9yfHyLkqqBjLR8qNYR+RvTdvpQL2sx4S+qV8xE2ud=D2AwBg@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: pinctrl-single: Fix error check condition
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: ext Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 13:14, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Nov 20, 2012 at 12:04 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>
>> *map should be tested for NULL instead of map.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>
> Thanks, patch applied.
>
Thanks

> As we are late in the kernel cycle and I haven't seen reports about
> regressions on this, it will wait for kernel v3.8.

OK.

>
> Yours,
> Linus Walleij



-- 
With warm regards,
Sachin
