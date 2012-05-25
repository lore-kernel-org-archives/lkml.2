Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2EYJKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:10:42 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:42920 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab2EYJKk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <1337933492-25361-1-git-send-email-balbi@ti.com>
References: <1337933492-25361-1-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Fri, 25 May 2012 14:40:18 +0530
Message-ID: <CAMQu2gxeB1h9aieJU_WvCK2rPPLYkOVN8gw0i8xBm6yEPRNmHQ@mail.gmail.com>
Subject: Re: [PATCH] misc: emif: fix compilation error
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de, svadivu@ti.com,
        aneesh@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 1:41 PM, Felipe Balbi <balbi@ti.com> wrote:
> commit 99d3eccf (ARM: OMAP4/5: EMIF: Probe
> Emif driver with initcall) introduced a compile
> error by not removing module_init() when adding
> postcore_initcall().
>
> This problem would've been caught by just compiling
> the driver as module.
>
> Fix the issue by removing module_init() from the
> driver.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/misc/emif.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/misc/emif.c b/drivers/misc/emif.c
> index 36fda8e..8725ea9 100644
> --- a/drivers/misc/emif.c
> +++ b/drivers/misc/emif.c

This driver is in drivers/memory now and this patch is
certainly not applicable. Looks like you might have seen
this issue with the older, internal version of the driver.

Regards
Santosh
