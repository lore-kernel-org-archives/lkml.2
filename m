Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0HQBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 21:16:58 -0400
Received: from ozlabs.org ([203.10.76.45]:49650 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0HQBQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 21:16:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 10:46:51 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, mst@redhat.com, Tejun Heo <tj@kernle.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org>
In-Reply-To: <1281977523-19335-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171046.53220.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 02:22:00 am Tejun Heo wrote:
> From: Tejun Heo <tj@kernle.org>
> 
> Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
> support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
> indicate the support for FUA.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

And also for the lguest-specific patch.

Thanks!
Rusty.
