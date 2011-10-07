Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326Ab1JGDs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:48:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44636 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1JGDs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-5-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-5-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 11:48:37 +0800
Message-ID: <CAMPhdO8jTemD+W8c+RqbhiaxBA1OSwcp1h4xbU7h1o__PH42zw@mail.gmail.com>
Subject: Re: [PATCH 04/26] net/pxa168_eth: add missing include of interrupt.h
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> interrupt.h is no longer implicitly included here, so manually
> add it instead.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.

> ---
>  drivers/net/pxa168_eth.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/pxa168_eth.c b/drivers/net/pxa168_eth.c
> index 1a3033d..d5a6cfc 100644
> --- a/drivers/net/pxa168_eth.c
> +++ b/drivers/net/pxa168_eth.c
> @@ -41,6 +41,7 @@
>  #include <linux/phy.h>
>  #include <linux/io.h>
>  #include <linux/types.h>
> +#include <linux/interrupt.h>
>  #include <asm/pgtable.h>
>  #include <asm/system.h>
>  #include <asm/cacheflush.h>
> --
> 1.7.5.4
>
>
