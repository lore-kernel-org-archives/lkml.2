Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2HVTj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:39:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab2HVTjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:39:54 -0400
Date: Wed, 22 Aug 2012 20:33:57 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Ben Hutchings <ben@decadent.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] mempolicy: Remove mempolicy sharing
Message-ID: <20120822193357.GE15058@suse.de>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de>
 <1345480594-27032-3-git-send-email-mgorman@suse.de>
 <20120822120314.9fc30d47.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120822120314.9fc30d47.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 12:03:14PM -0700, Andrew Morton wrote:
> On Mon, 20 Aug 2012 17:36:31 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > Dave Jones' system call fuzz testing tool "trinity" triggered the following
> > bug error with slab debugging enabled
> > 
> > ...
> >
> > Cc: <stable@vger.kernel.org>
> 
> The patch dosn't apply to 3.5 at all well.  I don't see much point in
> retaining the stable tag so I think I'll remove it, and suggest that
> you prepare a fresh patch for Greg and explain the situation?
> 

Sure. I'll do the backport at the time they get merged to mainline and
jump through the hoops. Thanks.

-- 
Mel Gorman
SUSE Labs
