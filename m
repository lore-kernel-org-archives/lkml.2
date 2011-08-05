Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1HEGEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 02:04:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19423 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab1HEGEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 02:04:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 04 Aug 2011 23:03:50 -0700
Message-ID: <4E3B87C2.3020304@nvidia.com>
Date: Fri, 5 Aug 2011 15:03:46 +0900
From: Jinyoung Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: aat2870 causes build failure in current upstream
References: <4E385B53.3040108@zytor.com> <20110804171725.GA12729@elte.hu>
In-Reply-To: <20110804171725.GA12729@elte.hu>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I try to check allmodconfig error issue for aat2870 backlight driver.
But I could not observing error message what you attached, building is 
successed.
Please let me know how to reproduce allmodconfig problem for aat2870 
backlight driver.

This is my repro step.
$ git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
$ cd linux-next
$ make allmodconfig
$ make

Thanks,
Jin.

2011-08-05 오전 2:17, Ingo Molnar 쓴 글:
>
> * H. Peter Anvin<hpa@zytor.com>  wrote:
>
>> Doing an "allmodconfig" on i386:
>>
>> drivers/built-in.o: In function `aat2870_bl_remove':
>> /home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:217:
>> undefined reference to `backlight_device_unregister'
>> drivers/built-in.o: In function `aat2870_bl_probe':
>> /home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:159:
>> undefined reference to `backlight_device_register'
>> /home/hpa/kernel/git.test/drivers/video/backlight/aat2870_bl.c:201:
>> undefined reference to `backlight_device_unregister'
>> make[2]: *** [.tmp_vmlinux1] Error 1
>> make[1]: *** [sub-make] Error 2
>> make[1]: Leaving directory `/home/hpa/kernel/git.test'
>
> The allmodconfig build is still broken upstream.
>
> Thanks,
>
> 	Ingo
