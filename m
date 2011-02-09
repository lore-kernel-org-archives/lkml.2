Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1BIPxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:53:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52720 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1BIPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:53:43 -0500
Message-ID: <4D52B810.403@oracle.com>
Date: Wed, 09 Feb 2011 07:51:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: linux-next: Tree for February 3 (netfilter)
References: <20110203160034.44ae3247.sfr@canb.auug.org.au> <20110204111511.1f4d6706.randy.dunlap@oracle.com> <4D524079.1000908@trash.net>
In-Reply-To: <4D524079.1000908@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D52B870.0071:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/11 23:21, Patrick McHardy wrote:
> Am 04.02.2011 20:15, schrieb Randy Dunlap:
>> On Thu, 3 Feb 2011 16:00:34 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20110202:
>>
>> When SYSCTL and PROC_FS and NETFILTER_NETLINK are not enabled:
>>
>> net/built-in.o: In function `try_to_load_type':
>> ip_set_core.c:(.text+0x3ab49): undefined reference to `nfnl_unlock'
>> ip_set_core.c:(.text+0x3ab4e): undefined reference to `nfnl_lock'
> 
> Does this patch fix the problem?

Yes, it does.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
