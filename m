Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab1AHHpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 02:45:54 -0500
Received: from verein.lst.de ([213.95.11.210]:49163 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1AHHpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 02:45:52 -0500
Date: Sat, 8 Jan 2011 08:45:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        Neil Brown <neilb@suse.de>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
        dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
        Ric Wheeler <rwheeler@redhat.com>, Josef Bacik <josef@redhat.com>
Subject: Re: Patch to issue pure flushes directly (Was: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent) by fsync
Message-ID: <20110108074524.GA13024@lst.de>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com> <20101130164124.GA30858@lst.de> <20110107235449.GT21922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107235449.GT21922@thunk.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 06:54:49PM -0500, Ted Ts'o wrote:
> This patch seemed like a good idea to me; I just checked linux-next,
> and looks like nothing like this is planned to be merged.  Just
> thought I would send a prod-o-gram to see what the current thinking
> was around adding something like this.

I haven't really gotten any feedback on the patch, so it fell on the
floor for a while.  I've managed to get some big system resources to
test the impact of it, and once I've got numbers I'll resend it as
separate patches for scsi and the block layer.

