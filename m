Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0HRKWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:22:10 -0400
Received: from ozlabs.org ([203.10.76.45]:59508 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0HRKWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:22:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Wed, 18 Aug 2010 19:52:02 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        mst@redhat.com
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <4C6A458B.5040407@kernel.org> <20100817132327.GA3347@lst.de>
In-Reply-To: <20100817132327.GA3347@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008181952.03093.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 10:53:27 pm Christoph Hellwig wrote:
> Given how little testing lguest gets compared to qemu I really don't
> want a protocol addition for it unless it really buys us something.
> Once we're done with this barrier conversion I plan into benchmarking
> FUA and a pre-flush tag on the command for virtio in real life setups,
> and see if it actually buys us anything.

Absolutely.  Lguest should follow, not lead!

Rusty.
