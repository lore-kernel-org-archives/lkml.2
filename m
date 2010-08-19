Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab0HSFQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:16:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40863 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab0HSFQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:16:18 -0400
Date: Thu, 19 Aug 2010 10:46:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Chris Webb <chris@arachsys.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Over-eager swapping
Message-ID: <20100819051610.GI28417@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100804032400.GA14141@localhost>
 <20100804095811.GC2326@arachsys.com>
 <20100804114933.GA13527@localhost>
 <20100804120430.GB23551@arachsys.com>
 <20100818143801.GA9086@localhost>
 <20100818144655.GX2370@arachsys.com>
 <20100818152103.GA11268@localhost>
 <1282147034.77481.33.camel@useless.localdomain>
 <20100818155825.GA2370@arachsys.com>
 <alpine.DEB.2.00.1008181112510.6294@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008181112510.6294@router.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux-foundation.org> [2010-08-18 11:13:03]:

> On Wed, 18 Aug 2010, Chris Webb wrote:
> 
> > > != 0.  And even then, zone reclaim should only reclaim file pages, not
> > > anon.  In theory...
> >
> > Hi. This is zero on all our machines:
> >
> > # sysctl vm.zone_reclaim_mode
> > vm.zone_reclaim_mode = 0
> 
> Set it to 1.
>

Isn't that bad in terms of how we treat the cost of remote node
allocations? Is local zone_reclaim() always a good thing or is it
something for chris to try and see if that helps his situation?

-- 
	Three Cheers,
	Balbir
