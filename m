Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2H0XIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:08:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2H0XH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120820080632.GD8450@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-14-git-send-email-lee.jones@linaro.org>
	<CACRpkdaem6t3mvy-_9e=GEgwWoeBQSoX3Hf1L=hjWsvLJdsVAQ@mail.gmail.com>
	<20120820080632.GD8450@gmail.com>
Date: Mon, 27 Aug 2012 16:07:58 -0700
Message-ID: <CACRpkdZRJ1yX-o8-NUuMzXMz5ebbp=H21Xa6JMy1y56Chq-T9g@mail.gmail.com>
Subject: Re: [PATCH 13/22] ARM: ux500: Fork MSP platform registration for
 step-by-step DT enablement
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 1:06 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, Aug 14, 2012 at 01:13:49PM +0200, Linus Walleij wrote:
>> On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > We've done this before and it worked well last time. Here we're
>> > duplicating a complex registration function to ease the process
>> > of enabling it for Device Tree. As there are quite a few steps
>> > taken during the registration process, it makes sense to break
>> > them up into more manageable chunks. This patch will aid us.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> I understand you have used this approach before so:
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Does this comment take back your previous one:
>
> NOTE: it seems this patch set contains some churn. First you
> add in the forked device init, put in a big chunk of code and
> then in the *same* patch set delete it again. It's not like
> we're dying to see all the development history... can this
> be squashed down a bit?
>
> ... hence leave the patch-set as it is?

No. I just meant leave it like that for the devices outside of this
set.

If you're adding and then removing *all* of them in this set,
why add them in the first place?

Yours,
Linus Walleij
