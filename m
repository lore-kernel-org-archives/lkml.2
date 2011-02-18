Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab1BRWfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:35:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41700 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1BRWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:35:05 -0500
Message-ID: <4D5EF43A.5040905@vflare.org>
Date: Sat, 19 Feb 2011 04:05:38 +0530
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow sharing xvmalloc for zram and zcache
References: <1297371646-11604-1-git-send-email-ngupta@vflare.org> <20110218212542.GI796@kroah.com>
In-Reply-To: <20110218212542.GI796@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2011 02:55 AM, Greg KH wrote:
> On Thu, Feb 10, 2011 at 04:00:46PM -0500, Nitin Gupta wrote:
>> Both zram and zcache use xvmalloc allocator. If xvmalloc
>> is compiled separately for both of them, we will get linker
>> error if they are both selected as "built-in". We can also
>> get linker error regarding missing xvmalloc symbols if zram
>> is not built.
>>
>> So, we now compile xvmalloc separately and export its symbols
>> which are then used by both of zram and zcache.
>>
>> Signed-off-by: Nitin Gupta<ngupta@vflare.org>
>
> This doesn't apply to my tree, care to respin it and resend?
>


The new patch:
https://lkml.org/lkml/2011/2/18/340

applies to staging-next branch of the staging-2.6 tree.

Thanks,
Nitin
