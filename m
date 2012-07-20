Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2GTIxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:53:47 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36181 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2GTIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:53:46 -0400
Message-ID: <50091C75.9030601@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 16:53:09 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mgalbraith@novell.com, mmokrejs@fold.natur.cuni.cz
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
References: <5008CBD4.6070907@linux.vnet.ibm.com> <20120720064156.GI16348@mwanda> <500915B9.2030104@linux.vnet.ibm.com> <20120720083619.GM16348@mwanda>
In-Reply-To: <20120720083619.GM16348@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12072008-1396-0000-0000-000001953B23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 04:36 PM, Dan Carpenter wrote:
> On Fri, Jul 20, 2012 at 04:24:25PM +0800, Michael Wang wrote:
>> On 07/20/2012 02:41 PM, Dan Carpenter wrote:
>>> My bug was fixed in March.  There was an email thread about it when
>>> the merge window opened but I can't find it...
>> Hi, Dan
>>
>> Thanks for your reply.
>>
>> Currently this issue won't appear because the
>> CONFIG_RCU_CPU_STALL_TIMEOUT=60, which is big enough to avoid the
>> warning info.
>>
>> So is this the fix you mentioned? or someone has find out the true
>> reason and fixed it?
> 
> I don't think there was an email thread on the RCU stall issue after
> all.  I'm not sure what how it was fixed.
> 
> The 60 second time out would have still triggered with my bug.  It
> was a complete system hang, the RCU stall message was just a
> debugging hint.  I was hitting the bug every couple days reliably on
> all my systems.

I see, looks like the stall info in your case is caused by a different
reason which should already be handled.

I do think that this warning won't appear with a normal machine working
normally without any buggie driver or wrong deployment...

Let's see what I can get from other reporters ;-)

Regards,
Michael Wang
> 
> regards,
> dan carpenter
> 


