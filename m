Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab0LAFW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:22:27 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43650 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0LAFWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:22:25 -0500
Date: Wed, 1 Dec 2010 10:52:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] Refactor zone_reclaim
Message-ID: <20101201052218.GK2746@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
 <20101130101520.17475.79978.stgit@localhost6.localdomain6>
 <20101201102329.89b96c54.kamezawa.hiroyu@jp.fujitsu.com>
 <20101201044634.GF2746@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101201044634.GF2746@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2010-12-01 10:16:34]:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-12-01 10:23:29]:
> 
> > On Tue, 30 Nov 2010 15:45:55 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Refactor zone_reclaim, move reusable functionality outside
> > > of zone_reclaim. Make zone_reclaim_unmapped_pages modular
> > > 
> > > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Why is this min_mapped_pages based on zone (IOW, per-zone) ?
> >
> 
> Kamezawa-San, this has been the design before the refactoring (it is
> based on zone_reclaim_mode and reclaim based on top of that).  I am
> reusing bits of existing technology. The advantage of it being
> per-zone is that it integrates well with kswapd. 
>

My local MTA failed to deliver the message, trying again. 

-- 
	Three Cheers,
	Balbir
