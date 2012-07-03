Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2GCLob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:44:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2GCLo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:44:29 -0400
Date: Tue, 3 Jul 2012 12:44:24 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120703114424.GC14154@suse.de>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120629112505.GF14154@suse.de>
 <20120701235458.GM19223@dastard>
 <20120702063226.GA32151@infradead.org>
 <20120702143215.GS14154@suse.de>
 <20120702193516.GX14154@suse.de>
 <20120703001928.GV19223@dastard>
 <20120703105951.GB14154@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120703105951.GB14154@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 11:59:51AM +0100, Mel Gorman wrote:
> > Can you run latencytop to see
> > if there is excessive starvation/wait times for allocation
> > completion?
> 
> I'm not sure what format you are looking for.  latencytop is shit for
> capturing information throughout a test and it does not easily allow you to
> record a snapshot of a test. You can record all the console output of course
> but that's a complete mess. I tried capturing /proc/latency_stats over time
> instead because that can be trivially sorted on a system-wide basis but
> as I write this I find that latency_stats was bust. It was just spitting out
> 
> Latency Top version : v0.1
> 
> and nothing else.  Either latency_stats is broken or my config is. Not sure
> which it is right now and won't get enough time on this today to pinpoint it.
> 

PEBKAC. Script that monitored /proc/latency_stats was not enabling
latency top via /proc/sys/kernel/latencytop

-- 
Mel Gorman
SUSE Labs
