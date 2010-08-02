Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0HBRpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:45:47 -0400
Received: from claw.goop.org ([74.207.240.146]:43419 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab0HBRpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:45:45 -0400
Message-ID: <4C570447.7050800@goop.org>
Date: Mon, 02 Aug 2010 10:45:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Stodden <daniel.stodden@citrix.com>
Subject: Re: [PATCH 00/16] xen/blkfront: various bugfixes and patches for
 blkfront
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com> <4C46577F.7050909@kernel.dk> <4C50CAAE.7020103@goop.org>
In-Reply-To: <4C50CAAE.7020103@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/28/2010 05:26 PM, Jeremy Fitzhardinge wrote:
>  On 07/20/2010 07:12 PM, Jens Axboe wrote:
>> On 07/20/2010 02:42 PM, Jeremy Fitzhardinge wrote:
>>> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>>>
>>> Hi Jens,
>>>
>>> This series has various updates to blkfront, including:
>>>   - support for dynamic device resizing
>>>   - bugfixes for device hotplug
>>>   - various races and bugs fixed
>>>
>>> It can be pulled from:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git 
>>> upstream/blkfront
>> They don't apply cleanly to the for-2.6.36 branch, it fails at patch 2:
>>
>> patching file drivers/block/xen-blkfront.c
>> Hunk #1 succeeded at 105 (offset 1 line).
>> Hunk #2 succeeded at 143 (offset 1 line).
>> Hunk #9 FAILED at 1080.
>> Hunk #10 succeeded at 1106 with fuzz 1 (offset 5 lines).
>> 1 out of 10 hunks FAILED -- saving rejects to file 
>> drivers/block/xen-blkfront.c.rej
>
> Could you pull again?  I've merged it into your branch (we don't need 
> any BKL locking), and added a couple of changes to fix some barrier 
> issues up.

Ping?

     J

