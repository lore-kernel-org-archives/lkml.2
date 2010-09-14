Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0INFRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:17:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35456 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0INFRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:17:20 -0400
Message-ID: <4C8F04D2.8020206@oracle.com>
Date: Mon, 13 Sep 2010 22:14:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Renninger <trenn@suse.de>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (driver-core
 tree related)
References: <20100907115426.fc0c3e13.sfr@canb.auug.org.au>	<20100907023404.GA11972@kroah.com>	<20100913085155.6b73c9cc.randy.dunlap@oracle.com>	<201009132126.14115.trenn@suse.de> <20100914143159.dca830f0.sfr@canb.auug.org.au>
In-Reply-To: <20100914143159.dca830f0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/10 21:31, Stephen Rothwell wrote:
> Hi Thomas,
> 
> On Mon, 13 Sep 2010 21:26:13 +0200 Thomas Renninger <trenn@suse.de> wrote:
>>
>> On Monday 13 September 2010 17:51:55 Randy Dunlap wrote:
>>> On Mon, 6 Sep 2010 19:34:04 -0700 Greg KH wrote:
>>>
>>>> On Tue, Sep 07, 2010 at 11:54:26AM +1000, Stephen Rothwell wrote:
>>>>>
>>>>> After merging the final tree, today's linux-next build (powerpc
>>>>> allnoconfig) produced this warning:
>>>>>
>>>>> kernel/params.c: In function 'parse_args':
>>>>> kernel/params.c:233: warning: the frame size of 1032 bytes is larger than 1024 bytes
>>>>>
>>>>> Introduced by commit 32e6407e9361cd1aac39ff6b744cad48d1802a08 ("Dynamic
>>>>> Debug: Introduce global fake module param module.ddebug") which added a
>>>>> 1024 byte array to the stack ...
>>>>
>>>> Wierd, why didn't this show up yesterday?  The patch was in that tree
>>>> then, right?
>>>>
>>>> Thomas, care to fix this up?
>>>  
>>> ping.  Is Thomas around??
>> Yep, sorry for not responding.
>>
>> I tried to reproduce this on ppc64, but above file compiled without
>> warning with dynamic debug set. Thus I thought this still came from the
>> old patch.
> 
> The report is for a powerpc allnoconfig build (see above) i.e. ppc32.


It also happens on x86_32 (i386).

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
