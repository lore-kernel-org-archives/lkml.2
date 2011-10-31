Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1JaHF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 03:05:58 -0400
Received: from brick.kernel.dk ([87.104.106.3]:35977 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab1JaHF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 03:05:56 -0400
Message-ID: <4EAE48D3.4090504@kernel.dk>
Date: Mon, 31 Oct 2011 08:05:55 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCHv4] virtio-blk: use ida to allocate disk index
References: <20111030192959.GA31143@redhat.com>
In-Reply-To: <20111030192959.GA31143@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-30 20:29, Michael S. Tsirkin wrote:
> Based on a patch by Mark Wu <dwu@redhat.com>
> 
> Current index allocation in virtio-blk is based on a monotonically
> increasing variable "index". This means we'll run out of numbers
> after a while.  It also could cause confusion about the disk
> name in the case of hot-plugging disks.
> Change virtio-blk to use ida to allocate index, instead.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Changes from Mark's versions:
>  use the new ida_simple_get
>  error handling cleanup
>  fix user after free
> 
> Works fine for me.
> 
> Jens, could you merge this for 3.2?
> That is, unless Rusty complains shortly ...

Yep, tentatively added.

-- 
Jens Axboe

