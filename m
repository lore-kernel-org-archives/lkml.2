Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0FQBiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:38:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47366 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0FQBiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:38:54 -0400
Message-ID: <4C197CB5.5020907@vflare.org>
Date: Thu, 17 Jun 2010 07:09:01 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] zram: generic RAM based compressed R/W block devices
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org> <4BFFEA95.9040505@vflare.org> <20100528162657.GA28781@kroah.com> <4C18337C.3040605@vflare.org> <20100616184355.GA14248@kroah.com>
In-Reply-To: <20100616184355.GA14248@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 12:13 AM, Greg KH wrote:
> On Wed, Jun 16, 2010 at 07:44:20AM +0530, Nitin Gupta wrote:
>> Hi Greg,
>>
>> On 05/28/2010 09:56 PM, Greg KH wrote:
>>> On Fri, May 28, 2010 at 09:38:53PM +0530, Nitin Gupta wrote:
>>>>
>>>> On 05/24/2010 07:48 PM, Nitin Gupta wrote:
>>>>> Creates RAM based block devices: /dev/zramX (X = 0, 1, ...).
>>>>> Pages written to these disks are compressed and stored in memory
>>>>> itself. These disks allow very fast I/O and compression provides
>>>>> good amounts of memory savings.
>>>>>
>>>>> This is enhancement over existing ramzswap driver which creates
>>>>> virtual block devices (/dev/ramzswapX) which could be used only
>>>>> as swap disks.
>>>>>
>>>>> Now, with the ability to handle any kind of I/O request, zram
>>>>> devices have lot more use cases:
>>>>>  - /tmp storage
>>>>>  - various caches under /var
>>>>>  - swap disks
>>>>>  - maybe even more! :)
>>>>>
>>>>> Performance numbers can be found at:
>>>>> http://code.google.com/p/compcache/wiki/zramperf
>>>>>
>>>>
>>>> Any reviews/comments, please?
>>>
>>> We are all busy with the .35-rc1 merge work at the moment, sorry.
>>>
>>
>> Can you please apply these patches to linux-next?
> 
> Yes, I'm working on it, I should get to it by the end of this week.
> 
>> or maybe for .35-rc3/rc4 too?
> 
> No, this is not a bugfix, why would it be acceptable for the .35 kernel
> release?
> 

Since its a staging driver, I thought any kind of changes can be pulled in
mainline too. Maybe I still don't understand how -staging works :)

Anyways, thanks for taking it in linux-next.

Nitin
