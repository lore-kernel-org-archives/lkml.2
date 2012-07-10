Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2GJTTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab2GJTTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:19:10 -0400
Date: Tue, 10 Jul 2012 15:18:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stankey, Robert" <Robert.Stankey@netapp.com>,
        "Moger, Babu" <Babu.Moger@netapp.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH v2] block: do not artificially constrain max_sectors for
 stacking drivers
Message-ID: <20120710191859.GB3831@redhat.com>
References: <F200AD42A082BC4088B232D13A916A8907E5DD64@SACEXCMBX02-PRD.hq.netapp.com>
 <20120709130052.GC30048@redhat.com>
 <20120709131611.GD30048@redhat.com>
 <20120709134041.GA30633@redhat.com>
 <20120709141416.GB30633@redhat.com>
 <20120709145711.GB30886@redhat.com>
 <20120709225725.GA1487@redhat.com>
 <F200AD42A082BC4088B232D13A916A8907E5F2AA@SACEXCMBX02-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F200AD42A082BC4088B232D13A916A8907E5F2AA@SACEXCMBX02-PRD.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10 2012 at  3:10pm -0400,
Chauhan, Vijay <Vijay.Chauhan@netapp.com> wrote:

> On Tuesday, July 10, 2012 4:27 AM, Mike Wrote:
> >As it happens, v2's changes to blk_limits_max_hw_sectors and
> >blk_queue_max_hw_sectors are not strictly required in order for existing
> >stacking drivers to have have an unconstrained max_sectors.  Dropping
> >those changes also allows for consistency across both block functions.
> >
> >So I'd be happy if v1 were to be staged for 3.6.  NetApp: it would be
> >great if you could confirm that v1 does in fact address the max_sectors
> >issue you reported.
> >
> >Thanks,
> >Mike
> 
> Mike, Thanks for the quick fix. I verified with Patch v1 and it resolves this issue.

Great, thanks for testing.  I assume Jens will be OK with staging v1 of
this patch for 3.6 once he gets back from vacation.

Jens please feel free to add the following to v1's patch header:

Tested-by: Vijay Chauhan <vijay.chauhan@netapp.com>
