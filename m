Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2HHGWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab2HHGWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:22:09 -0400
Message-ID: <50220616.6060508@redhat.com>
Date: Wed, 08 Aug 2012 14:24:22 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Shaohua Li <shli@kernel.org>,
        Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V6 0/2] Improve virtio-blk performance
References: <1344329235-17449-1-git-send-email-asias@redhat.com> <20120807091630.GB2651@lst.de> <5021D87C.4050400@redhat.com>
In-Reply-To: <5021D87C.4050400@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 11:09 AM, Asias He wrote:
> On 08/07/2012 05:16 PM, Christoph Hellwig wrote:
>> On Tue, Aug 07, 2012 at 04:47:13PM +0800, Asias He wrote:
>>> 1) Ramdisk device
>>>       With bio-based IO path, sequential read/write, random read/write
>>>       IOPS boost         : 28%, 24%, 21%, 16%
>>>       Latency improvement: 32%, 17%, 21%, 16%
>>> 2) Fusion IO device
>>>       With bio-based IO path, sequential read/write, random read/write
>>>       IOPS boost         : 11%, 11%, 13%, 10%
>>>       Latency improvement: 10%, 10%, 12%, 10%
>>
>> Do you also have numbers for normal SAS/SATA disks?  The changelog should
>> have a reall good explanation of why this is optional, and numbers are a
>> very important part of that.

Yes. I posted the numbers on normal SATA disks a few days ago in the 
thread with Sasha. Will add that data and explanation of why optional to 
the changelog

-- 
Asias
