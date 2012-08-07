Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2HGJQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:16:33 -0400
Received: from verein.lst.de ([213.95.11.211]:35592 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab2HGJQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:16:31 -0400
Date: Tue, 7 Aug 2012 11:16:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Shaohua Li <shli@kernel.org>,
        Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V6 0/2] Improve virtio-blk performance
Message-ID: <20120807091630.GB2651@lst.de>
References: <1344329235-17449-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344329235-17449-1-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:47:13PM +0800, Asias He wrote:
> 1) Ramdisk device
>      With bio-based IO path, sequential read/write, random read/write
>      IOPS boost         : 28%, 24%, 21%, 16%
>      Latency improvement: 32%, 17%, 21%, 16%
> 2) Fusion IO device
>      With bio-based IO path, sequential read/write, random read/write
>      IOPS boost         : 11%, 11%, 13%, 10%
>      Latency improvement: 10%, 10%, 12%, 10%

Do you also have numbers for normal SAS/SATA disks?  The changelog should
have a reall good explanation of why this is optional, and numbers are a
very important part of that.

