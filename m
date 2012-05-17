Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965744Ab2EQKzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:55:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33104 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965360Ab2EQKzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:55:40 -0400
Message-ID: <4FB4D910.3020905@mvista.com>
Date: Thu, 17 May 2012 14:55:12 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, david.daney@cavium.com
Subject: Re: [PATCH 7/8] MIPS: smp: Warn on too early irq enable
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com> <1337249410-7162-8-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1337249410-7162-8-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-05-2012 14:10, Yong Zhang wrote:

> From: Yong Zhang<yong.zhang@windriver.com>

> Just to catch a potential issue.

    Grammar nitpicking ahead. :-)

> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>
> ---
>   arch/mips/kernel/smp.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)

> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index 042145f..0d48598 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -130,6 +130,11 @@ asmlinkage __cpuinit void start_secondary(void)
>
>   	synchronise_count_slave();
>
> +	/*
> +	 * irq will be enabled in ->smp_finish(), enable it too early

    s/enable/enabling/

WBR, Sergei

