Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1A1LSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 06:18:43 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49175 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1A1LSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 06:18:41 -0500
Date: Fri, 28 Jan 2011 16:48:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
Message-ID: <20110128111833.GD5054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
 <20110125051015.13762.13429.stgit@localhost6.localdomain6>
 <AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
 <AANLkTi=qXsDjN5Jp4m3QMgVnckoAM7uE9_Hzn6CajP+c@mail.gmail.com>
 <AANLkTinfxXc04S9VwQcJ9thFff=cP=icroaiVLkN-GeH@mail.gmail.com>
 <20110128064851.GB5054@balbir.in.ibm.com>
 <AANLkTikw_j0JJVqEsj1xThoashiOARg+8BgcLKrvkV3U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTikw_j0JJVqEsj1xThoashiOARg+8BgcLKrvkV3U@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MinChan Kim <minchan.kim@gmail.com> [2011-01-28 16:24:19]:

> >
> > But the assumption for LRU order to change happens only if the page
> > cannot be successfully freed, which means it is in some way active..
> > and needs to be moved no?
> 
> 1. holded page by someone
> 2. mapped pages
> 3. active pages
> 
> 1 is rare so it isn't the problem.
> Of course, in case of 3, we have to activate it so no problem.
> The problem is 2.
>

2 is a problem, but due to the size aspects not a big one. Like you
said even lumpy reclaim affects it. May be the reclaim code could
honour may_unmap much earlier. 

-- 
	Three Cheers,
	Balbir
