Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab0JGDML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:12:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52382 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0JGDMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:12:10 -0400
Date: Thu, 7 Oct 2010 08:42:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: containers@lists.linux-foundation.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Restrict size of page_cgroup->flags
Message-ID: <20101007031203.GK4195@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101006142314.GG4195@balbir.in.ibm.com>
 <20101007085858.0e07de59.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101007085858.0e07de59.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-10-07 08:58:58]:

> On Wed, 6 Oct 2010 19:53:14 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > I propose restricting page_cgroup.flags to 16 bits. The patch for the
> > same is below. Comments?
> > 
> > 
> > Restrict the bits usage in page_cgroup.flags
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Restricting the flags helps control growth of the flags unbound.
> > Restriciting it to 16 bits gives us the possibility of merging
> > cgroup id with flags (atomicity permitting) and saving a whole
> > long word in page_cgroup
> > 
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Doesn't make sense until you show the usage of existing bits.

??

> And I guess 16bit may be too large on 32bit systems.

too large on 32 bit systems? My intention is to keep the flags to 16
bits and then use cgroup id for the rest and see if we can remove
mem_cgroup pointer

> Nack for now.
>

The issue is - do you see further growth of flags?
 
> Thanks,
> -Kame
> 

-- 
	Three Cheers,
	Balbir
