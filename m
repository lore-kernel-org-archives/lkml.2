Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab2HCHGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:06:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2HCHGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:06:12 -0400
Message-ID: <501B78E0.5040307@redhat.com>
Date: Fri, 03 Aug 2012 15:08:16 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Shaohua Li <shli@kernel.org>,
        Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V5 0/4] Improve virtio-blk performance
References: <1343888757-25723-1-git-send-email-asias@redhat.com> <501AF3E3.6090403@kernel.dk>
In-Reply-To: <501AF3E3.6090403@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 05:40 AM, Jens Axboe wrote:
> On 08/02/2012 08:25 AM, Asias He wrote:
>> Hi folks,
>>
>> This version added REQ_FLUSH and REQ_FUA support as suggested by Christoph and
>> rebased against latest linus's tree.
>>
>> Jens, could you please consider picking up the dependencies 1/4 and
>> 2/4 in your tree. Thanks!
>
> Pickedup, thanks for getting that done!

Cheers. Thanks, Jens.

-- 
Asias
