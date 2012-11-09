Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2KIQXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:23:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33095 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2KIQXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:23:38 -0500
Date: Fri, 9 Nov 2012 16:23:27 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v11 3/7] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20121109162327.GT3886@csn.ul.ie>
References: <cover.1352256081.git.aquini@redhat.com>
 <4ea10ef1eb1544e12524c8ca7df20cf621395463.1352256087.git.aquini@redhat.com>
 <20121109121133.GP3886@csn.ul.ie>
 <20121109145321.GB4308@optiplex.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121109145321.GB4308@optiplex.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 12:53:22PM -0200, Rafael Aquini wrote:
> > <SNIP>
> > If you get the barrier issue sorted out then feel free to add
> > 
> > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > 
> 
> I believe we can drop the barriers stuff, as the locking scheme is now provinding
> enough protection against collisions between isolation page scanning and
> balloon_leak() page release (the major concern that has lead to the barriers
> originally)
> 
> I'll refactor this patch with no barriers and ensure a better commentary on the
> aforementioned locking scheme and resubmit, if it's OK to everyone
> 

Sounds good to me. When they are dropped again feel free to stick my ack
on for the compaction and migration parts. The virtio aspects are up to
someone else :)

-- 
Mel Gorman
SUSE Labs
