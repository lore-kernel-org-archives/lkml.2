Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0JPCJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:09:24 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18664 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab0JPCJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:09:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMOjuEx5LcUp/2dsb2JhbAChMHK/IoVJBI9K
Date: Sat, 16 Oct 2010 13:09:18 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101016020918.GA5294@amd>
References: <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
 <20101015130259.GA3207@amd>
 <20101015132938.GA3936@amd>
 <20101015173345.GA10731@amd>
 <20101015175247.GA6737@infradead.org>
 <20101015180219.GA11110@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015180219.GA11110@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 05:02:19AM +1100, Nick Piggin wrote:
> On Fri, Oct 15, 2010 at 01:52:47PM -0400, Christoph Hellwig wrote:
> > Thanks for trying to get back to a technical discussion.  Maybe we
> > can just move the technical comments to direct replies to the patches
> > and leave this not very helpful subthread behind?
> 
> I had plenty of other technical comments which you ignored about
> per-zone shrinkers and stragegy to merge the overall series. If you
> are going to keep claiming these are show stoppers, please address
> my comments there too.

Ping?

