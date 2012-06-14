Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2FNC4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab2FNC4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:56:06 -0400
Message-ID: <4FD95311.6020507@redhat.com>
Date: Thu, 14 Jun 2012 10:57:21 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH RFC 1/2] block: Add blk_bio_map_sg() helper
References: <1339573307-11537-1-git-send-email-asias@redhat.com> <1339573307-11537-2-git-send-email-asias@redhat.com> <20120614023156.GB3766@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120614023156.GB3766@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 10:31 AM, Tejun Heo wrote:
> On Wed, Jun 13, 2012 at 03:41:46PM +0800, Asias He wrote:
>> Add a helper to map a bio to a scatterlist, modelled after
>> blk_rq_map_sg.
>>
>> This helper is useful for any driver that wants to create
>> a scatterlist from its ->make_request_fn method.
>
> This may not be possible but I really wanna avoid having two copies of
> that complex logic.  Any chance blk_rq_map_bio() can be implemented in
> a way that allows blk_rq_map_sg() can be built on top of it?  Also,
> please include proper docbook style function comment on new public API
> functions.


OK. Will do. I guess you mean building blk_rq_map_sg() on top of 
blk_bio_map_sg().


-- 
Asias


