Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1D0GHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:07:17 -0400
Received: from ozlabs.org ([203.10.76.45]:52183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab1D0GHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:07:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Liu Yuan <namei.unix@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] drivers, block: virtio_blk: Replace cryptic number with the macro
In-Reply-To: <1303584566-11621-1-git-send-email-namei.unix@gmail.com>
References: <1303584566-11621-1-git-send-email-namei.unix@gmail.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Wed, 27 Apr 2011 14:46:59 +0930
Message-ID: <87fwp4l1dg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011 02:49:26 +0800, Liu Yuan <namei.unix@gmail.com> wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> It is easier to figure out the context by reading SCSI_SENSE_BUFFERSIZE
> instead of plain '96'.
> 
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>

Thanks, applied!

Cheers,
Rusty.
