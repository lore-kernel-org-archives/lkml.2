Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2JHDT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 23:19:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56435 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JHDT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 23:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO_HYzn1nJfDoiCYU5oxfk-BL0t=0VeLCPYESb1_jzV_yQ@mail.gmail.com>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
	<1349195816-2225-6-git-send-email-arnd@arndb.de>
	<CAMPhdO_HYzn1nJfDoiCYU5oxfk-BL0t=0VeLCPYESb1_jzV_yQ@mail.gmail.com>
Date: Mon, 8 Oct 2012 11:19:24 +0800
Message-ID: <CAN1soZy2w-uO-SMPQpDuUs7DJCqQh48BeGbrwtBopuqY1cDVOw@mail.gmail.com>
Subject: Re: [PATCH 05/17] ARM: pxa: remove sharpsl_fatal_check function
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Stanislav Brabec <utx@penguin.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 10:38 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Wed, Oct 3, 2012 at 12:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> The sharpsl_fatal_check has not been used since Pavel Machek removed
>> the caller in 99f329a2b "pxa/sharpsl_pm: zaurus c3000 aka spitz: fix
>> resume". Nobody has complained since 2009, so it's safe to assume we
>> can just remove the function.
>>
>> Without this patch, building corgi_defconfig results in:
>>
>> /home/arnd/linux-arm/arch/arm/mach-pxa/sharpsl_pm.c:693:12: warning: 'sharpsl_fatal_check' defined but not used [-Wunused-function]
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Pavel Machek <pavel@ucw.cz>
>> Cc: Stanislav Brabec <utx@penguin.cz>
>> Cc: Eric Miao <eric.y.miao@gmail.com>
>> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
> Let's get it cleaned up firstly. One can always reference the history for a
> sample implementation later if this is needed in the future.
>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
