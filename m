Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0FPCOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 22:14:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41583 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab0FPCOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 22:14:08 -0400
Message-ID: <4C18337C.3040605@vflare.org>
Date: Wed, 16 Jun 2010 07:44:20 +0530
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

Hi Greg,

On 05/28/2010 09:56 PM, Greg KH wrote:
> On Fri, May 28, 2010 at 09:38:53PM +0530, Nitin Gupta wrote:
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

Can you please apply these patches to linux-next? or maybe for .35-rc3/rc4 too?

Thanks,
Nitin
