Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab0GHSqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:46:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38826 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab0GHSqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:46:48 -0400
Message-ID: <4C361CD7.1050007@oracle.com>
Date: Thu, 08 Jul 2010 11:45:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Samium Gromoff <_deepfire@feelingofgreen.ru>
Subject: Re: [PATCH -mmotm] 8250_early: fix printk format warnings
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org> <20100702182437.977c8ef8.randy.dunlap@oracle.com> <20100708183710.GC31823@kroah.com>
In-Reply-To: <20100708183710.GC31823@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C361D0B.0178:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/10 11:37, Greg KH wrote:
> On Fri, Jul 02, 2010 at 06:24:37PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix printk format warnings in serial-mmio32-support-for-8250_earlyc.patch:
>>
>> drivers/serial/8250_early.c:207: warning: format '%p' expects type 'void *', but argument 3 has type 'long long unsigned int'
>> drivers/serial/8250_early.c:210: warning: format '%p' expects type 'void *', but argument 2 has type 'long long unsigned int'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>
>> Cc: Greg KH <greg@kroah.com>
>> ---
>>  drivers/serial/8250_early.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- mmotm-2010-0701-1219.orig/drivers/serial/8250_early.c
>> +++ mmotm-2010-0701-1219/drivers/serial/8250_early.c
>> @@ -202,12 +202,12 @@ static int __init parse_options(struct e
>>  	}
>>  
>>  	if (mmio || mmio32)
>> -		printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
>> +		printk(KERN_INFO "Early serial console at MMIO%s 0x%llu (options '%s')\n",
> 
> Odd, my tree doesn't have this change in it, where is it coming from?

A patch in mmotm from Samium Gromoff.
mmotm patch file name is "serial-mmio32-support-for-8250_earlyc.patch".

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
