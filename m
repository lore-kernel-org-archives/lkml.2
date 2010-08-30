Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab0H3GOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 02:14:00 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59323 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0H3GN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 02:13:59 -0400
Message-ID: <4C7B4C1F.7010003@linux.vnet.ibm.com>
Date: Mon, 30 Aug 2010 11:43:51 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org, mikey@neuling.org, linux-next@vger.kernel.org
Subject: Re: Power machines fail to boot after build being successful
References: <4C764F52.5050707@linux.vnet.ibm.com> <2311.1282871746@neuling.org> <20100827120144.1736a2f6.sfr@canb.auug.org.au>
In-Reply-To: <20100827120144.1736a2f6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 August 2010 07:31 AM, Stephen Rothwell wrote:
> Hi Mikey,
>
> On Fri, 27 Aug 2010 11:15:46 +1000 Michael Neuling<mikey@neuling.org>  wrote:
>    
>>      
>>> After successfully building the kernel version
>>> 2.6.36-rc2-git4(commitid d4348c678977c) with the config file
>>> attached(used make oldconfig), P5 and P6 power machines fails to
>>> reboot with the following logs
>>>
>>> Logs collected while rebooting into today next, same occurs with the
>>> upstream kernel too.
>>>        
>> This will fix your problem:
>> http://patchwork.ozlabs.org/patch/62757/
>>      
> I have seen something similar in my linux-next boot tests, so I will add
> this patch to linux-next for today.
>    
Hi,

The same problem occurs on the linux-tree , now that since the patch is integrated into linux-next,
im not able to find the problem with linux-next-20100827.

When will the patch be integrated with the linux-tree.

Thanks
Divya

