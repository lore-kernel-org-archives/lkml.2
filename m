Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0HRQeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:34:31 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:33519 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0HRQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:34:29 -0400
Date: Wed, 18 Aug 2010 17:32:03 +0100
From: Chris Webb <chris@arachsys.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Over-eager swapping
Message-ID: <20100818163203.GD2370@arachsys.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008181112510.6294@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

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

I'll try this tonight: setting this to one and readding swap on one of the
problem machines.

Best wishes,

Chris.
