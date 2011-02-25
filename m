Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1BYBMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 20:12:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57101 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab1BYBMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 20:12:09 -0500
Date: Fri, 25 Feb 2011 02:12:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110225011205.GK5818@one.firstfloor.org>
References: <1298425922-23630-1-git-send-email-andi@firstfloor.org> <1298425922-23630-9-git-send-email-andi@firstfloor.org> <20110225005155.GH23252@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225005155.GH23252@random.random>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 01:51:55AM +0100, Andrea Arcangeli wrote:
> On Tue, Feb 22, 2011 at 05:52:02PM -0800, Andi Kleen wrote:
> > +	"thp_direct_alloc",
> > +	"thp_daemon_alloc",
> > +	"thp_direct_fallback",
> > +	"thp_daemon_alloc_failed",
> 
> I've been wondering if we should do s/daemon/khugepaged/ or

Fine by me.

> s/daemon/collapse/.
> 
> And s/direct/fault/.

Fine for me too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
