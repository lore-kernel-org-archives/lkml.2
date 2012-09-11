Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab2IKOlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759158Ab2IKOlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:41:16 -0400
Date: Tue, 11 Sep 2012 10:41:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>, drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120911144102.GE12039@redhat.com>
References: <3029802.oqG0dEY71l@fat-tyre>
 <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120905100724.GA27527@soda.linbit>
 <20120906212952.GP29092@google.com>
 <20120907084221.GD7028@soda.linbit>
 <20120910225442.GE7677@google.com>
 <20120910230654.GF7677@google.com>
 <20120910233159.GE19739@google.com>
 <20120911155820.74f1f918@notabene.brown>
 <20120911082501.GH7028@soda.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911082501.GH7028@soda.linbit>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 10:25:01AM +0200, Lars Ellenberg wrote:

[..]
> "To enforce write-after-write dependencies, you *have* to drain the
> queue (do we have a generic interface available for that?),
> or at least wait for the completion of all the requests you
> (potentially) depend upon, before even submitting the dependent request.

I think you need to wait for all previous IOs (you are dependent on) to finish.

Thanks
Vivek
