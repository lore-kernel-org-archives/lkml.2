Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2ENCqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:46:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64260 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2ENCqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAG9bXvkm6KVRpca9-YBq9oRiUyFLeaD+gwysCjpMO4Xo69XBXQ@mail.gmail.com>
References: <CAG9bXvkn6bm1xXpBxqvOxxzSrPPRdvP7RzKrfhSVJebN54psHQ@mail.gmail.com>
	<CAG9bXvkm6KVRpca9-YBq9oRiUyFLeaD+gwysCjpMO4Xo69XBXQ@mail.gmail.com>
Date: Sun, 13 May 2012 19:46:34 -0700
X-Google-Sender-Auth: 3eAYFS_hdFDulHFGOsCLDanKwMw
Message-ID: <CAMbhsRSe-SNd8iDResx=Yqja96OD69unCH_WpcmFEH08jzv3EA@mail.gmail.com>
Subject: Re: [PATCH] cpu_pm: fix some typos in comments
From: Colin Cross <ccross@android.com>
To: Raul Xiong <raulxiong@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, khilman@ti.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        santosh.shilimkar@ti.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 7:43 PM, Raul Xiong <raulxiong@gmail.com> wrote:
> 2012/5/11 Raul Xiong <raulxiong@gmail.com>:
>> Fix some comment typos in function names
>>
>> Signed-off-by: Raul Xiong <raulxiong@gmail.com>
>> ---
>>  kernel/cpu_pm.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
>> index 249152e..957b151 100644
>> --- a/kernel/cpu_pm.c
>> +++ b/kernel/cpu_pm.c
>> @@ -81,7 +81,7 @@ int cpu_pm_unregister_notifier(struct notifier_block *nb)
>>  EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
>>
>>  /**
>> - * cpm_pm_enter - CPU low power entry notifier
>> + * cpu_pm_enter - CPU low power entry notifier
>>  *
>>  * Notifies listeners that a single CPU is entering a low power state that may
>>  * cause some blocks in the same power domain as the cpu to reset.
>> @@ -115,7 +115,7 @@ int cpu_pm_enter(void)
>>  EXPORT_SYMBOL_GPL(cpu_pm_enter);
>>
>>  /**
>> - * cpm_pm_exit - CPU low power exit notifier
>> + * cpu_pm_exit - CPU low power exit notifier
>>  *
>>  * Notifies listeners that a single CPU is exiting a low power state that may
>>  * have caused some blocks in the same power domain as the cpu to reset.
>> @@ -139,7 +139,7 @@ int cpu_pm_exit(void)
>>  EXPORT_SYMBOL_GPL(cpu_pm_exit);
>>
>>  /**
>> - * cpm_cluster_pm_enter - CPU cluster low power entry notifier
>> + * cpu_cluster_pm_enter - CPU cluster low power entry notifier
>>  *
>>  * Notifies listeners that all cpus in a power domain are entering a low power
>>  * state that may cause some blocks in the same power domain to reset.
>> @@ -174,7 +174,7 @@ int cpu_cluster_pm_enter(void)
>>  EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
>>
>>  /**
>> - * cpm_cluster_pm_exit - CPU cluster low power exit notifier
>> + * cpu_cluster_pm_exit - CPU cluster low power exit notifier
>>  *
>>  * Notifies listeners that all cpus in a power domain are exiting form a
>>  * low power state that may have caused some blocks in the same power domain
>
>
> Hi Colin, all,
>
> Is there any problem to accept this patch?
>
>
> Raul
> Best Regards

Nicolas Pitre posted a similar patch in March that fixed these plus
one more typo, and got two acks.  That one should probably go in.
