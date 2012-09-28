Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033334Ab2I1Vp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:45:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:33592 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965055Ab2I1Vpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:45:52 -0400
Message-ID: <50661A81.7000501@windriver.com>
Date: Fri, 28 Sep 2012 16:45:37 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 09/12] tty/console: fix warnings in drivers/tty/serial/kgdboc.c
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-10-git-send-email-arnd@arndb.de>
In-Reply-To: <1348868177-21205-10-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 04:36 PM, Arnd Bergmann wrote:
> The con_debug_leave/con_debug_enter functions are stubbed out
> by defining them to (0), which causes harmless build warnings.
> Using proper inline functions is the normal way to deal with
> this.
>
> Without this patch, building the ARM bcm2835_defconfig results in:
>
> drivers/tty/serial/kgdboc.c: In function 'kgdboc_pre_exp_handler':
> drivers/tty/serial/kgdboc.c:279:3: warning: statement with no effect [-Wunused-value]
> drivers/tty/serial/kgdboc.c: In function 'kgdboc_post_exp_handler':
> drivers/tty/serial/kgdboc.c:293:3: warning: statement with no effect [-Wunused-value]


Thanks Arnd!

I'll put this in kgdb-next for the upcoming merge window, unless Greg pulls it into his queue first.

Acked-by: Jason Wessel <jason.wessel@windriver.com>

Cheers,
Jason.

