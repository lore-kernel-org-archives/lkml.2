Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab1EMKGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:06:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab1EMKGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:06:04 -0400
Date: Fri, 13 May 2011 11:05:56 +0100
From: Mel Gorman <mgorman@suse.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Message-ID: <20110513100556.GB3569@suse.de>
References: <1305127773-10570-4-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1105120942050.24560@router.home>
 <1305213359.2575.46.camel@mulgrave.site>
 <alpine.DEB.2.00.1105121024350.26013@router.home>
 <1305214993.2575.50.camel@mulgrave.site>
 <1305215742.27848.40.camel@jaguar>
 <1305225467.2575.66.camel@mulgrave.site>
 <1305229447.2575.71.camel@mulgrave.site>
 <1305230652.2575.72.camel@mulgrave.site>
 <BANLkTindTdL9a4VxZk_AXrWLQf6QWqjz5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTindTdL9a4VxZk_AXrWLQf6QWqjz5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 09:16:24AM +0300, Pekka Enberg wrote:
> Hi,
> 
> On Thu, May 12, 2011 at 11:04 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Confirmed, I'm afraid ... I can trigger the problem with all three
> > patches under PREEMPT.  It's not a hang this time, it's just kswapd
> > taking 100% system time on 1 CPU and it won't calm down after I unload
> > the system.
> 
> OK, that's good to know. I'd still like to take patches 1-2, though. Mel?
> 

Wait for a V2 please. __GFP_REPEAT should also be removed.

-- 
Mel Gorman
SUSE Labs
