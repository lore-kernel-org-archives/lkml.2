Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2HBG0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab2HBG0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:26:12 -0400
Message-ID: <501A1E00.2010605@redhat.com>
Date: Thu, 02 Aug 2012 14:28:16 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH V3 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <971756309.4742543.1343457753475.JavaMail.root@redhat.com> <501610E0.8000504@redhat.com> <5016383A.5090008@redhat.com> <20120730134424.GC6041@lst.de>
In-Reply-To: <20120730134424.GC6041@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 09:44 PM, Christoph Hellwig wrote:
> On Mon, Jul 30, 2012 at 09:31:06AM +0200, Paolo Bonzini wrote:
>> You only need to add REQ_FLUSH support.  The virtio-blk protocol does
>> not support REQ_FUA, because there's no easy way to do it in userspace.
>
> A bio-based driver needs to handle both REQ_FLUSH and REQ_FUA as it does
> not get the sequencing of REQ_FUA into REQ_FLUSH that request based drivers
> can request.  To what the REQ_FUA request gets translated is a different story.

I just sent out V5 to support both REQ_FLUSH AND REQ_FUA.
Thanks, Christoph!

-- 
Asias
