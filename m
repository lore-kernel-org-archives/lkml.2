Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1GaSTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 14:19:11 -0400
Received: from verein.lst.de ([213.95.11.211]:40057 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1GaSTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 14:19:06 -0400
Date: Sun, 31 Jul 2011 20:19:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Avishay Traeger <avishay@il.ibm.com>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] virtio_blk: add block topology support
Message-ID: <20110731181905.GA14288@lst.de>
References: <20100129190158.GA25122@lst.de> <201001301529.49848.rusty@rustcorp.com.au> <20100130201910.GA19811@lst.de> <201002011140.05761.rusty@rustcorp.com.au> <CAB9v_DHEieOMYYLr90Yqw_SmMKGKZxdCeOtC0fs-eSuz6ooV+Q@mail.gmail.com> <8762mw2hpe.fsf@rustcorp.com.au> <CAB9v_DH1Y6B3mOMR=6Tgc3WYXXtgS4FEoUntNSt97mtqpQ8qyA@mail.gmail.com> <871ux84bfp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ux84bfp.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 02:22:42PM +0930, Rusty Russell wrote:
> > I guess you could just remove VIRTIO_BLK_F_SECTOR_MAX from the spec.
> > Linux did not implement it, and virtualbox does not have virtio block
> > support at all. Are there any other known users, who might have
> > implemented the  VIRTIO_BLK_F_SECTOR_MAX feature?
> 
> Did qemu implement it?  If not, we'll simply kill it, and pretend it
> never happened...

It was never added to either qemu or the kernel.  It would really help
if we had a copy of the spec in a readable format (that is plain text)
in major implementations of virtio like qemu and the kernel.
