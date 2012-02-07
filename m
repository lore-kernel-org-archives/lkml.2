Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2BGI6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:58:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2BGI6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:58:41 -0500
Message-ID: <4F30E7BC.90903@monstr.eu>
Date: Tue, 07 Feb 2012 09:58:36 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial] microblaze: Fix typo in early_printk.c
References: <1328538217-2010-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1328538217-2010-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masanari Iida wrote:
> Correct spelling "remaping" to "remapping" in
> arch/microblaze/kernel/early_printk.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/microblaze/kernel/early_printk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
> index 8356e47..742c247 100644
> --- a/arch/microblaze/kernel/early_printk.c
> +++ b/arch/microblaze/kernel/early_printk.c
> @@ -171,7 +171,7 @@ void __init remap_early_printk(void)
>  {
>  	if (!early_console_initialized || !early_console)
>  		return;
> -	printk(KERN_INFO "early_printk_console remaping from 0x%x to ",
> +	printk(KERN_INFO "early_printk_console remapping from 0x%x to ",
>  								base_addr);
>  	base_addr = (u32) ioremap(base_addr, PAGE_SIZE);
>  	printk(KERN_CONT "0x%x\n", base_addr);

Applied to microblaze-next tree.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
