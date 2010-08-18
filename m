Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0HRQU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:20:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:16867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab0HRQU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:20:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,228,1280732400"; 
   d="scan'208";a="648960550"
Date: Thu, 19 Aug 2010 00:20:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Chris Webb <chris@arachsys.com>, Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Over-eager swapping
Message-ID: <20100818162000.GA15859@localhost>
References: <20100804022148.GA5922@localhost>
 <AANLkTi=wRPXY9BTuoCe_sDCwhnRjmmwtAf_bjDKG3kXQ@mail.gmail.com>
 <20100804032400.GA14141@localhost>
 <20100804095811.GC2326@arachsys.com>
 <20100804114933.GA13527@localhost>
 <20100804120430.GB23551@arachsys.com>
 <20100818143801.GA9086@localhost>
 <20100818144655.GX2370@arachsys.com>
 <20100818152103.GA11268@localhost>
 <alpine.DEB.2.00.1008181056350.4025@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008181056350.4025@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 11:57:09PM +0800, Christoph Lameter wrote:
> On Wed, 18 Aug 2010, Wu Fengguang wrote:
> 
> > Andi, Christoph and Lee:
> >
> > This looks like an "unbalanced NUMA memory usage leading to premature
> > swapping" problem.
> 
> Is zone reclaim active? It may not activate on smaller systems leading
> to an unbalance memory usage between node.

Another possibility is, there are many low watermark page allocations,
leading to kswapd page out activities.

Thanks,
Fengguang
