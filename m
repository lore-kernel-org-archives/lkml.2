Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1H2Vim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:38:42 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:45036 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab1H2Vil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:38:41 -0400
Message-ID: <4E5C06DF.60508@nod.at>
Date: Mon, 29 Aug 2011 23:38:39 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 8/9] um: fix strrchr problems
References: <1314634419-24766-1-git-send-email-richard@nod.at> <1314634419-24766-9-git-send-email-richard@nod.at> <20110829142705.5be82d7c.akpm@linux-foundation.org>
In-Reply-To: <20110829142705.5be82d7c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.08.2011 23:27, schrieb Andrew Morton:
>
>> Subject: [PATCH 8/9] um: fix strrchr problems
>
> What are the problems?
>
> On Mon, 29 Aug 2011 18:13:38 +0200
> Richard Weinberger<richard@nod.at>  wrote:
>
>> From: Al Viro<viro@ftp.linux.org.uk>
>>
>> Several years old patch, originally by jdike, I think...
>>
>> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> ---
>>   arch/um/Makefile |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/um/Makefile b/arch/um/Makefile
>> index fab8121..c0f712c 100644
>> --- a/arch/um/Makefile
>> +++ b/arch/um/Makefile
>> @@ -41,7 +41,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
>>   KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
>>   	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
>>   	-Din6addr_loopback=kernel_in6addr_loopback \
>> -	-Din6addr_any=kernel_in6addr_any
>> +	-Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr
>>
>>   KBUILD_AFLAGS += $(ARCH_INCLUDE)
>
> z:/usr/src/linux-3.1-rc4>  grep -r kernel_strrchr .
> z:/usr/src/linux-3.1-rc4>
>
> ok, I give up.  How does this work?

*grrr*, you can drop this patch.
To my excuse, I've dropped it already from my queue but after pulling a 
second time from Al's git branch it made it again into my queue and I 
forgot about it, sorry!

Thanks,
//richard
