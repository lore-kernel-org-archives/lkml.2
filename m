Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0FPB4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 21:56:36 -0400
Received: from ozlabs.org ([203.10.76.45]:53615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab0FPB4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 21:56:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: support barriers without FLUSH feature
Date: Wed, 16 Jun 2010 11:26:32 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100615124348.GA25804@lst.de>
In-Reply-To: <20100615124348.GA25804@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161126.32894.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 10:13:48 pm Christoph Hellwig wrote:
> If we want to support barriers with the cache=writethrough mode in qemu
> we need to tell the block layer that we only need queue drains to
> implement a barrier.  Follow the model set by SCSI and IDE and assume
> that there is no volatile write cache if the host doesn't advertize it.
> While this might imply working barriers on old qemu versions or other
> hypervisors that actually have a volatile write cache this is only a
> cosmetic issue - these hypervisors don't guarantee any data integrity
> with or without this patch, but with the patch we at least provide
> data ordering.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks, applied.

Cheers,
Rusty.
