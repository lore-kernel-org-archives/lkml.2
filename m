Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0KIKgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:36:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0KIKgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:36:38 -0500
Date: Tue, 9 Nov 2010 05:36:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, petero2@telia.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
        mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de,
        leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com,
        swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org,
        konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/5] block: make blkdev_get/put() handle exclusive access
Message-ID: <20101109103620.GA18355@infradead.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
 <1288628129-12811-5-git-send-email-tj@kernel.org>
 <20101103161059.GA13621@infradead.org>
 <4CD9239E.2080209@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD9239E.2080209@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:34:06AM +0100, Tejun Heo wrote:
> So, after the above points, I decided to keep @mode.  It is a bit
> awkward but the other way didn't seem too hip either.  Any better
> ideas?

Let's keep it for now and revisit it later.

> That will make the number of functions multiplied by two -
> blkdev_get_by_path_stacked() and blkdev_get_by_dev_stacked().  The
> symlinking for stacked drivers is an oddball feature which is and will
> be only used by md and dm.  So, I think it's better to keep it
> separate and oddball.

Oh well.  I still don't like it, but let keeps it simple to make
progress for now.

