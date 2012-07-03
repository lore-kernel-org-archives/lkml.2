Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2GCOA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2GCOA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:00:27 -0400
Message-ID: <4FF2FB5D.5030102@redhat.com>
Date: Tue, 03 Jul 2012 22:02:05 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Sasha Levin <levinsasha928@gmail.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <1340002390-3950-4-git-send-email-asias@redhat.com> <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com> <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <1340019575.22848.2.camel@lappy> <4FDFE926.7030309@redhat.com> <87r4svxcjw.fsf@rustcorp.com.au> <4FF10B31.60609@redhat.com> <8762a6y89v.fsf@rustcorp.com.au> <4FF2F417.2010209@redhat.com>
In-Reply-To: <4FF2F417.2010209@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 09:31 PM, Paolo Bonzini wrote:
> Il 02/07/2012 08:41, Rusty Russell ha scritto:
>>> With the same workload in guest, the guest fires 200K requests to host
>>> with merges enabled in guest (echo 0 > /sys/block/vdb/queue/nomerges),
>>> while the guest fires 40000K requests to host with merges disabled in
>>> guest (echo 2 > /sys/block/vdb/queue/nomerges). This show that the merge
>>> in block layer reduces the total number of requests fire to host a lot
>>> (40000K / 200K = 20).
>>>
>
> 40000 / 200 is 200, not 20. :)

Crap, I wrote one more zero here. Actually, it is 4000K. So the factor 
is still 4000K/200k = 20 ;-)

-- 
Asias


