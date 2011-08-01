Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1HAXZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:25:43 -0400
Received: from ozlabs.org ([203.10.76.45]:43793 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab1HAXZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Avishay Traeger <avishay@il.ibm.com>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] virtio_blk: add block topology support
In-Reply-To: <20110731181905.GA14288@lst.de>
References: <20100129190158.GA25122@lst.de> <201001301529.49848.rusty@rustcorp.com.au> <20100130201910.GA19811@lst.de> <201002011140.05761.rusty@rustcorp.com.au> <CAB9v_DHEieOMYYLr90Yqw_SmMKGKZxdCeOtC0fs-eSuz6ooV+Q@mail.gmail.com> <8762mw2hpe.fsf@rustcorp.com.au> <CAB9v_DH1Y6B3mOMR=6Tgc3WYXXtgS4FEoUntNSt97mtqpQ8qyA@mail.gmail.com> <871ux84bfp.fsf@rustcorp.com.au> <20110731181905.GA14288@lst.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 01 Aug 2011 14:52:10 +0930
Message-ID: <87pqkp3dvh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jul 2011 20:19:05 +0200, Christoph Hellwig <hch@lst.de> wrote:
> On Sat, Jul 30, 2011 at 02:22:42PM +0930, Rusty Russell wrote:
> > > I guess you could just remove VIRTIO_BLK_F_SECTOR_MAX from the spec.
> > > Linux did not implement it, and virtualbox does not have virtio block
> > > support at all. Are there any other known users, who might have
> > > implemented the  VIRTIO_BLK_F_SECTOR_MAX feature?
> > 
> > Did qemu implement it?  If not, we'll simply kill it, and pretend it
> > never happened...
> 
> It was never added to either qemu or the kernel.  It would really help
> if we had a copy of the spec in a readable format (that is plain text)
> in major implementations of virtio like qemu and the kernel.

That's a really good idea.  I've prepared a patch which puts the latest
version in the kernel source (Documentation/virtio/virtio-spec.txt).

Thanks!
Rusty.

