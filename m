Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2GCNEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:04:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab2GCNET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:04:19 -0400
Date: Tue, 3 Jul 2012 14:04:14 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120703130414.GD14154@suse.de>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120629112505.GF14154@suse.de>
 <20120701235458.GM19223@dastard>
 <20120702063226.GA32151@infradead.org>
 <20120702143215.GS14154@suse.de>
 <20120702193516.GX14154@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120702193516.GX14154@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 08:35:16PM +0100, Mel Gorman wrote:
> > <SNIP>
> >
> It was obvious very quickly that there were two distinct regression so I
> ran two bisections. One led to a XFS and the other led to an i915 patch
> that enables RC6 to reduce power usage.
> 
> [c999a223: xfs: introduce an allocation workqueue]
> [aa464191: drm/i915: enable plain RC6 on Sandy Bridge by default]
> 
> gdm was running on the machine so i915 would have been in use. 

Bah, more PEBKAC. gdm was *not* running on this machine. i915 is loaded
but X is not.

-- 
Mel Gorman
SUSE Labs
