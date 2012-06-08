Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2FHDd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:33:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36989 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2FHDd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:33:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120608124448.2ff862098d474dc6a567dc46@canb.auug.org.au>
References: <20120608124448.2ff862098d474dc6a567dc46@canb.auug.org.au>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 8 Jun 2012 11:33:05 +0800
X-Google-Sender-Auth: aqa2JkPmqewZlugkNwiXm7jvlBI
Message-ID: <CAK5ve-KnxRbP60ATZLT3M-P5Kc8mr0MhpypCoLq0t_jNwE_yqg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the leds tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I fixed this, since I put 2 bug fixing patches in my fixes-for-3.5
branch, which were missing in for-next.

-Bryan

On Fri, Jun 8, 2012 at 10:44 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bryan,
>
> After merging the leds tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/leds/led-core.c: In function 'led_set_software_blink':
> drivers/leds/led-core.c:44:2: error: implicit declaration of function 'led_stop_software_blink' [-Werror=implicit-function-declaration]
>
> Caused by commit 12b204f41034 ("leds: fix led_brightness_set when
> soft-blinking").  Please build test this stuff.
>
> I have used the leds tree from next-20120607 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
