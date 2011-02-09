Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1BIQKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:10:00 -0500
Received: from stinky.trash.net ([213.144.137.162]:54362 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1BIQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:09:59 -0500
Message-ID: <4D52BC47.8080709@trash.net>
Date: Wed, 09 Feb 2011 17:09:43 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: linux-next: Tree for February 3 (netfilter)
References: <20110203160034.44ae3247.sfr@canb.auug.org.au> <20110204111511.1f4d6706.randy.dunlap@oracle.com> <4D524079.1000908@trash.net> <4D52B810.403@oracle.com>
In-Reply-To: <4D52B810.403@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2011 16:51, schrieb Randy Dunlap:
> On 02/08/11 23:21, Patrick McHardy wrote:
>> Am 04.02.2011 20:15, schrieb Randy Dunlap:
>>> On Thu, 3 Feb 2011 16:00:34 +1100 Stephen Rothwell wrote:
>>>
>>>> Hi all,
>>>>
>>>> Changes since 20110202:
>>>
>>> When SYSCTL and PROC_FS and NETFILTER_NETLINK are not enabled:
>>>
>>> net/built-in.o: In function `try_to_load_type':
>>> ip_set_core.c:(.text+0x3ab49): undefined reference to `nfnl_unlock'
>>> ip_set_core.c:(.text+0x3ab4e): undefined reference to `nfnl_lock'
>>
>> Does this patch fix the problem?
> 
> Yes, it does.  Thanks.
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 

Thanks, I'll push it upstream with my next batch of patches.
