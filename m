Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1BJNzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:55:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52755 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1BJNzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:55:06 -0500
Message-ID: <4D53EE35.1060906@monstr.eu>
Date: Thu, 10 Feb 2011 14:55:01 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/52] kstrtox: convert microblaze
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com> <1296915654-7458-46-git-send-email-adobriyan@gmail.com>
In-Reply-To: <1296915654-7458-46-git-send-email-adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

you forget to CC me. I will test it.

Michal

> ---
>  arch/microblaze/kernel/traps.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
> index ba034d4..ac81870 100644
> --- a/arch/microblaze/kernel/traps.c
> +++ b/arch/microblaze/kernel/traps.c
> @@ -27,7 +27,7 @@ static unsigned long kstack_depth_to_print;	/* 0 == entire stack */
>  
>  static int __init kstack_setup(char *s)
>  {
> -	return !strict_strtoul(s, 0, &kstack_depth_to_print);
> +	return !kstrtoul(s, 0, &kstack_depth_to_print);
>  }
>  __setup("kstack=", kstack_setup);
>  


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
