Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2EaFsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:48:40 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41131 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2EaFsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:48:39 -0400
Date: Thu, 31 May 2012 11:17:03 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -V7 01/14] hugetlb: rename max_hstate to
 hugetlb_max_hstate
Message-ID: <20120531054703.GF24855@skywalker.linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120531004838.GC401@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531004838.GC401@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12053020-3568-0000-0000-000001E74252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 08:48:40PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 30, 2012 at 08:08:46PM +0530, Aneesh Kumar K.V wrote:
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > Rename max_hstate to hugetlb_max_hstate.  We will be using this from other
> > subsystems like hugetlb controller in later patches.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Acked-by: Hillf Danton <dhillf@gmail.com>
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> 
> Your SOB needs to be the last thing.

I started with patches in -next, because Andrew had few fixup on top of last
patch series. So I ended up with this format. I have fixed them locally now

-aneesh

