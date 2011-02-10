Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab1BJVUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:20:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58121 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1BJVUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:20:10 -0500
Message-ID: <4D5456AD.5010703@vflare.org>
Date: Fri, 11 Feb 2011 02:50:45 +0530
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow sharing xvmalloc for zram and zcache
References: <1297371646-11604-1-git-send-email-ngupta@vflare.org> <4D5453CB.7050206@oracle.com> <4D5454CC.1000609@vflare.org> <4D5455CD.3000507@oracle.com>
In-Reply-To: <4D5455CD.3000507@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 02:47 AM, Randy Dunlap wrote:
> On 02/10/11 13:12, Nitin Gupta wrote:
>> On 02/11/2011 02:38 AM, Randy Dunlap wrote:
>>> On 02/10/11 13:00, Nitin Gupta wrote:
>>>> Both zram and zcache use xvmalloc allocator. If xvmalloc
>>>> is compiled separately for both of them, we will get linker
>>>> error if they are both selected as "built-in". We can also
>>>> get linker error regarding missing xvmalloc symbols if zram
>>>> is not built.
>>>>
>>>> So, we now compile xvmalloc separately and export its symbols
>>>> which are then used by both of zram and zcache.
>>>>
>>>> Signed-off-by: Nitin Gupta<ngupta@vflare.org>
>>>
>>> Acked-by: Randy Dunlap<randy.dunlap@oracle.com>
>>>
>>>
>>> but what does this patch apply to?  It does not apply cleanly to
>>> linux-next of 20110210.
>>>
>>
>> This applies to staging-2.6. I thought linux-next won't be that
>> different so as to produce conflicts. Can you please send reject files,
>> or let me fetch linux-next tree and will soon post patch against the same.
>
> I'll let you fetch linux-next.  I merged it by hand and test-built it
> successfully.
>

So, can you post the patch against linux-next then? :)

Thanks,
Nitin

