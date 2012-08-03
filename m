Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2HCHJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab2HCHI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:08:58 -0400
Message-ID: <501B7989.2080903@redhat.com>
Date: Fri, 03 Aug 2012 15:11:05 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Tejun Heo <tj@kernel.org>, Shaohua Li <shli@kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH V5 3/4] virtio-blk: Add bio-based IO path for virtio-blk
References: <1343888757-25723-1-git-send-email-asias@redhat.com> <1343888757-25723-4-git-send-email-asias@redhat.com> <20120802222814.GA5854@redhat.com>
In-Reply-To: <20120802222814.GA5854@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 06:28 AM, Michael S. Tsirkin wrote:
> On Thu, Aug 02, 2012 at 02:25:55PM +0800, Asias He wrote:
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index c0bbeb4..95cfeed 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -14,6 +14,9 @@
>>
>>   #define PART_BITS 4
>>
>> +static bool use_bio;
>> +module_param(use_bio, bool, S_IRUGO);
>> +
>>   static int major;
>>   static DEFINE_IDA(vd_index_ida);
>>
>
> OK, but eventually, you plan to make this use a feature bit, yes?

Yes, I think so.

-- 
Asias
