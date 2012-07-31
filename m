Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2GaIlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 04:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab2GaIlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 04:41:11 -0400
Message-ID: <50179AA2.5040708@redhat.com>
Date: Tue, 31 Jul 2012 16:43:14 +0800
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
References: <971756309.4742543.1343457753475.JavaMail.root@redhat.com> <501610E0.8000504@redhat.com> <20120730134322.GB6041@lst.de>
In-Reply-To: <20120730134322.GB6041@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 09:43 PM, Christoph Hellwig wrote:
> On Mon, Jul 30, 2012 at 12:43:12PM +0800, Asias He wrote:
>> I think we can add REQ_FLUSH & REQ_FUA support to bio path and that
>> deserves another patch.
>
> Adding it is a requirement for merging the code.
>

OK. Will add that.

-- 
Asias
