Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab0CYR1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:27:30 -0400
Received: from xenotime.net ([72.52.64.118]:45018 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750938Ab0CYR11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:27:27 -0400
Message-ID: <4BAB9CFB.4000304@xenotime.net>
Date: Thu, 25 Mar 2010 10:27:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gelma.net>
CC: linux-doc@vger.kernel.org, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, Ben Hutchings <ben@decadent.org.uk>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 07/16] Staging: sep: sep_driver.c: duplicated include
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net> <1269537767-7553-8-git-send-email-andrea.gelmini@gelma.net>
In-Reply-To: <1269537767-7553-8-git-send-email-andrea.gelmini@gelma.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/10 10:22, Andrea Gelmini wrote:
> drivers/staging/sep/sep_driver.c: linux/sched.h is included more than once.
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Hi,

You don't need to be sending these patches to the linux-doc mailing list.
Thanks.

> ---
>  drivers/staging/sep/sep_driver.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
> index 265de79..9be1fb7 100644
> --- a/drivers/staging/sep/sep_driver.c
> +++ b/drivers/staging/sep/sep_driver.c
> @@ -39,7 +39,6 @@
>  #include <linux/mm.h>
>  #include <linux/poll.h>
>  #include <linux/wait.h>
> -#include <linux/sched.h>
>  #include <linux/pci.h>
>  #include <linux/firmware.h>
>  #include <asm/ioctl.h>


-- 
~Randy
