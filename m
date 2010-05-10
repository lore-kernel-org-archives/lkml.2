Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0EJRzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:55:32 -0400
Received: from bamako.nerim.net ([62.4.17.28]:50565 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab0EJRz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:55:28 -0400
Date: Mon, 10 May 2010 19:55:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] i2c: use <linux/io.h> instead of <asm/io.h>
Message-ID: <20100510195524.3dabcdd2@hyperion.delvare>
In-Reply-To: <0D753D10438DA54287A00B0270842697636ECB4E89@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636ECB4E89@AUSP01VMBX24.collaborationhost.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 12:53:57 -0500, H Hartley Sweeten wrote:
> As warned by checkpatch.pl, <linux/io.h> should be used instead of
> <asm.io.h>.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/drivers/i2c/busses/i2c-ali1535.c b/drivers/i2c/busses/i2c-ali1535.c
> index bd8f1e4..906a3ca 100644
> --- a/drivers/i2c/busses/i2c-ali1535.c
> +++ b/drivers/i2c/busses/i2c-ali1535.c
> @@ -60,7 +60,7 @@
>  #include <linux/i2c.h>
>  #include <linux/init.h>
>  #include <linux/acpi.h>
> -#include <asm/io.h>
> +#include <linux/io.h>
> (...)

Applied, thanks.

-- 
Jean Delvare
