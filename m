Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab0JHQ7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:59:39 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33976 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab0JHQ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:59:38 -0400
Date: Fri, 8 Oct 2010 22:29:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
Message-ID: <20101008165930.GH5327@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101008104852.803E.A69D9226@jp.fujitsu.com>
 <20101008090427.GB5327@balbir.in.ibm.com>
 <alpine.DEB.2.00.1010081044530.30029@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010081044530.30029@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [2010-10-08 10:45:16]:

> On Fri, 8 Oct 2010, Balbir Singh wrote:
> 
> > I am not sure if this makes sense, since RECLAIM_DISTANCE is supposed
> > to be a hardware parameter. Could you please help clarify what the
> > access latency of a node with RECLAIM_DISTANCE 20 to that of a node
> > with RECLAIM_DISTANCE 30 is? Has the hardware definition of reclaim
> > distance changed?
> 
> 10 is the local distance. So 30 should be 3x the latency that a local
> access takes.
>

Does this patch then imply that we should do zone_reclaim only for 3x
nodes and not 2x nodes as we did earlier.
 
> > I suspect the side effect is the zone_reclaim_mode is not set to 1 on
> > bootup for the 2-4 socket machines you mention, which results in
> > better VM behaviour?
> 
> Right.
> 

-- 
	Three Cheers,
	Balbir
