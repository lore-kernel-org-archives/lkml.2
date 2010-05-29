Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0E2BVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 21:21:20 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:42965 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab0E2BVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 21:21:19 -0400
Message-ID: <4C006C11.7030309@vflare.org>
Date: Sat, 29 May 2010 06:51:21 +0530
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
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org> <4BFFEA95.9040505@vflare.org> <20100528162657.GA28781@kroah.com>
In-Reply-To: <20100528162657.GA28781@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 09:56 PM, Greg KH wrote:
> On Fri, May 28, 2010 at 09:38:53PM +0530, Nitin Gupta wrote:
>> Hi All,
>>
>> On 05/24/2010 07:48 PM, Nitin Gupta wrote:
>>> Creates RAM based block devices: /dev/zramX (X = 0, 1, ...).
>>> Pages written to these disks are compressed and stored in memory
>>> itself. These disks allow very fast I/O and compression provides
>>> good amounts of memory savings.
>>>
>>> This is enhancement over existing ramzswap driver which creates
>>> virtual block devices (/dev/ramzswapX) which could be used only
>>> as swap disks.
>>>
>>> Now, with the ability to handle any kind of I/O request, zram
>>> devices have lot more use cases:
>>>  - /tmp storage
>>>  - various caches under /var
>>>  - swap disks
>>>  - maybe even more! :)
>>>
>>> Performance numbers can be found at:
>>> http://code.google.com/p/compcache/wiki/zramperf
>>>
>>
>> Any reviews/comments, please?
> 
> We are all busy with the .35-rc1 merge work at the moment, sorry.
> 

Thanks for your reply.

Ok, in the meantime, I will further test it and keep building upon it.
When rc1 workload is over, I think all this can be merged in linux-next?

Thanks,
Nitin

