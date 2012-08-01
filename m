Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2HAPmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:42:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56193 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab2HAPmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:42:22 -0400
Message-ID: <50194E54.5040909@ti.com>
Date: Wed, 1 Aug 2012 11:42:12 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>, <nico@linaro.org>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 06/22] ARM: LPAE: use phys_addr_t in alloc_init_pud()
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-7-git-send-email-cyril@ti.com> <50191C46.4090902@mvista.com>
In-Reply-To: <50191C46.4090902@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2012 8:08 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 01-08-2012 3:04, Cyril Chemparathy wrote:
>
>> From: Vitaly Andrianov <vitalya@ti.com>
>
>> This patch fixes the alloc_init_pud() function to use phys_addr_t
>> instead of
>> unsigned long when passing in the phys argument.
>
>> This is an extension to commit
>> 97092e0c56830457af0639f6bd904537a150ea4a, which
>
>     Please also specify that commit's summary in parens.

Thanks Sergei.  Will do so.  I'm assuming you meant headline and not 
summary.

>
>> applied similar changes elsewhere in the ARM memory management code.
>
>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
>
> WBR, Sergei
>

-- 
Thanks
- Cyril
