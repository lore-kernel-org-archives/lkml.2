Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1G3FUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 01:20:25 -0400
Received: from ozlabs.org ([203.10.76.45]:47110 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1G3FUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 01:20:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Avishay Traeger <avishay@il.ibm.com>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] virtio_blk: add block topology support
In-Reply-To: <CAB9v_DH1Y6B3mOMR=6Tgc3WYXXtgS4FEoUntNSt97mtqpQ8qyA@mail.gmail.com>
References: <20100129190158.GA25122@lst.de> <201001301529.49848.rusty@rustcorp.com.au> <20100130201910.GA19811@lst.de> <201002011140.05761.rusty@rustcorp.com.au> <CAB9v_DHEieOMYYLr90Yqw_SmMKGKZxdCeOtC0fs-eSuz6ooV+Q@mail.gmail.com> <8762mw2hpe.fsf@rustcorp.com.au> <CAB9v_DH1Y6B3mOMR=6Tgc3WYXXtgS4FEoUntNSt97mtqpQ8qyA@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 30 Jul 2011 14:22:42 +0930
Message-ID: <871ux84bfp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 22:09:49 +0300, Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> VIRTIO_BLK_F_TOPOLOGY and VIRTIO_BLK_F_SECTOR_MAX features use the
> same bit, don't they?

Yes, spec bug.

> I guess you could just remove VIRTIO_BLK_F_SECTOR_MAX from the spec.
> Linux did not implement it, and virtualbox does not have virtio block
> support at all. Are there any other known users, who might have
> implemented the  VIRTIO_BLK_F_SECTOR_MAX feature?

Did qemu implement it?  If not, we'll simply kill it, and pretend it
never happened...

Thanks,
Rusty.
