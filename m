Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1EDWb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:31:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab1EDWbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:31:18 -0400
Date: Thu, 5 May 2011 00:31:15 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Dave Chinner <david@fromorbit.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/6] writeback fixes and trace events
Message-ID: <20110504223115.GM6968@quack.suse.cz>
References: <20110504091707.910929441@intel.com>
 <20110504094654.GA31151@infradead.org>
 <20110504095637.GA2101@localhost>
 <20110504100609.GE9114@dastard>
 <9B76908F-0E95-421A-8CDA-39B7AF7DA681@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B76908F-0E95-421A-8CDA-39B7AF7DA681@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-05-11 09:12:54, Ted Tso wrote:
> On May 4, 2011, at 6:06 AM, Dave Chinner wrote:
> 
> > Does anyone actaully testing filesystems use the -mm tree? I'm
> > pretty sure that no-one in the XFS world does, and I don't think
> > that any ext4 or btrfs folk do, either....
> 
> I don't.   I agree that it really would be great if there was a separate
> git tree for the writeback changes, since that way it becomes possible to
> test just the writeback changes, and not worry about other potential
> stability problems introduced by changes in the -mm tree....
  OK. We'd still push changes to Linus via Andrew but have them also
accumulated in that tree for testing. So we'd have a branch with changes
sitting in -mm (likely to go to Linus in near future) and then possibly
other branches with things brewing for people to try out. Does that make
sense? I can setup that tree and maintain it. Or Fengguang, do you want
to do it?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
