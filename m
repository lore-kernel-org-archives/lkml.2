Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0HYUDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:03:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0HYUDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:03:15 -0400
Date: Wed, 25 Aug 2010 22:02:24 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jack@suse.cz, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Message-ID: <20100825200223.GE2738@quack.suse.cz>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
 <1282751267-3530-27-git-send-email-tj@kernel.org>
 <20100825155842.GA3229@lst.de>
 <20100825160032.GC3229@lst.de>
 <4C753D75.2010305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C753D75.2010305@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 25-08-10 17:57:41, Tejun Heo wrote:
> On 08/25/2010 06:00 PM, Christoph Hellwig wrote:
> > On Wed, Aug 25, 2010 at 05:58:42PM +0200, Christoph Hellwig wrote:
> >> On Wed, Aug 25, 2010 at 05:47:43PM +0200, Tejun Heo wrote:
> >>> From: Christoph Hellwig <hch@infradead.org>
> >>>
> >>> ext4 already uses synchronous discards, no need to add I/O barriers.
> >>
> >> This needs the patch that Jan sent in reply to my initial version merged
> >> into it.
> > 
> > Actually the jbd2 patch needs it merged, but the point still stands.
> 
> Yeah, wasn't sure about that one.  Has anyone tested it?  I'll be
> happy to merge it but I have no idea whether it's correct or not and
> Jan didn't seem to have tested it so...  Jan, shall I merge the patch?
  I'm quite confident the patch is correct so you can merge it I think but
tomorrow I'll give it some crash testing together with the rest of your
patch set in KVM to be sure.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
