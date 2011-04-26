Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1DZLIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:08:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33543 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1DZLIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:08:10 -0400
Message-ID: <4DB6A736.3030609@mvista.com>
Date: Tue, 26 Apr 2011 15:06:30 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        "Kevin Hilman (supporter:TI DAVINCI MACHIN...,commit_signer:15/17=88%)" 
	<khilman@ti.com>,
        "Russell King (maintainer:ARM PORT)" <linux@arm.linux.org.uk>,
        "Michael Williamson (commit_signer:6/17=35%)" 
	<michael.williamson@criticallink.com>,
        "Cyril Chemparathy (commit_signer:3/17=18%)" <cyril@ti.com>,
        "Sergei Shtylyov (commit_signer:2/17=12%)" <sshtylyov@ru.mvista.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/11] da850: pruss platform specific additions.
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-4-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1303474109-6212-4-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-04-2011 16:08, Subhasish Ghosh wrote:

> This patch adds the platform device and assignes the platform resources
> for the PRUSS mfd driver.

> Signed-off-by: Subhasish Ghosh<subhasish@mistralsolutions.com>

[...]

> diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
> index 09b8ddb..0c23035 100644
> --- a/arch/arm/mach-davinci/include/mach/da8xx.h
> +++ b/arch/arm/mach-davinci/include/mach/da8xx.h
[...]
>   #include<mach/edma.h>
> @@ -73,6 +75,7 @@ extern unsigned int da850_max_speed;
>   #define DA8XX_DDR2_CTL_BASE	0xb0000000
>   #define DA8XX_ARM_RAM_BASE	0xffff0000
>   #define DA8XX_SHARED_RAM_BASE	0x80000000
> +#define DA8XX_PRUSS_MEM_BASE	0x01C30000

    Keep the list sorted please. Also, this macro doesn't seem used outside 
devices-da8xx.c, so should be moved there...

WBR, Sergei
