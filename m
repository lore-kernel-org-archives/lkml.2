Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab2KWHg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:36:28 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60584 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab2KWHg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:36:27 -0500
MIME-Version: 1.0
In-Reply-To: <0c8a01cdc715$1312c410$39384c30$%kim@samsung.com>
References: <1353300961-22632-1-git-send-email-sachin.kamat@linaro.org>
	<0c8a01cdc715$1312c410$39384c30$%kim@samsung.com>
Date: Fri, 23 Nov 2012 08:36:26 +0100
Message-ID: <CACRpkdakRO4qgerra9Vdvpph7=9vpKt7Sc9sOZJxSZPTgfm0QA@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: Samsung: Do not initialise statics to 0
From: Linus Walleij <linus.walleij@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 12:49 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Sachin Kamat wrote:
>>
>> Static variables are initialised to 0 by GCC.
>> Fixes the following checkpatch error:
>> ERROR: do not initialise statics to 0 or NULL
>> FILE: pinctrl/pinctrl-samsung.c:50:
>> static unsigned int pin_base = 0;
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> (...)
>
> Looks OK to me.
>
> Linus, can I pick this up in my tree?

Yes, go ahead:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
