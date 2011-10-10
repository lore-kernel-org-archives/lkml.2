Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1JJQv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:51:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54943 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab1JJQvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:51:25 -0400
Date: Mon, 10 Oct 2011 12:51:16 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: [patch]ext4: add block plug for .writepages
Message-ID: <20111010165116.GX7948@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Shaohua Li <shaohua.li@intel.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <1317004226.29510.172.camel@sli10-conroe>
 <20110926073025.GB21079@infradead.org>
 <1317022727.29510.175.camel@sli10-conroe>
 <20110926094554.GA30827@infradead.org>
 <1317179380.22361.8.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317179380.22361.8.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:09:40AM +0800, Shaohua Li wrote:
> I searched a little bit, looks only ext4 need it. here is the patch.
> 
> 
> Add block plug for ext4 .writepages. Though ext4 .writepages
> already handles request merge very well, block plug is still
> helpful to reduce block lock contention.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Thanks, applied.

					- Ted
