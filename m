Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab2FMEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:25:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38331 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2FMEZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120613141041.199421c4b922655cbcfbe14d@canb.auug.org.au>
References: <20120613141041.199421c4b922655cbcfbe14d@canb.auug.org.au>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 13 Jun 2012 12:25:05 +0800
X-Google-Sender-Auth: tuisKAKRBQAr9A4XIVgyZF-5W5E
Message-ID: <CAK5ve-JZ6zH=GZ2CHovNty56LbtXSWhPCU6Nanfh9rHBnws6Cw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the leds tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 12:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bryan,
>
> After merging the leds tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/leds/led-core.c: In function 'led_set_software_blink':
> drivers/leds/led-core.c:44:2: error: implicit declaration of function 'led_stop_software_blink' [-Werror=implicit-function-declaration]
>
> Caused by commit eb91300a9786 ("leds: fix led_brightness_set when
> soft-blinking").
>
> This is exactly the problem I reported on June 8 and was fixed in
> next-20120612 ...
>
> I have used the leds tree from next-20120612 for today.

Thanks for raising this. I rebuilt the for-next branch.

-Bryan
