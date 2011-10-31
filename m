Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1KACRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 22:17:18 -0400
Received: from ozlabs.org ([203.10.76.45]:42287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1KACRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 22:17:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCHv4] virtio-blk: use ida to allocate disk index
In-Reply-To: <4EAE48D3.4090504@kernel.dk>
References: <20111030192959.GA31143@redhat.com> <4EAE48D3.4090504@kernel.dk>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 01 Nov 2011 10:25:04 +1030
Message-ID: <8762j4wwbr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011 08:05:55 +0100, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-10-30 20:29, Michael S. Tsirkin wrote:
> > Based on a patch by Mark Wu <dwu@redhat.com>
> > 
> > Current index allocation in virtio-blk is based on a monotonically
> > increasing variable "index". This means we'll run out of numbers
> > after a while.  It also could cause confusion about the disk
> > name in the case of hot-plugging disks.
> > Change virtio-blk to use ida to allocate index, instead.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Changes from Mark's versions:
> >  use the new ida_simple_get
> >  error handling cleanup
> >  fix user after free
> > 
> > Works fine for me.
> > 
> > Jens, could you merge this for 3.2?
> > That is, unless Rusty complains shortly ...
> 
> Yep, tentatively added.

Thanks!

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
