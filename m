Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0JVEjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:39:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51544 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0JVEjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:39:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Oct 2010 13:34:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "Steven J. Magnani" <steve@digidescorp.com>, linux-mm@kvack.org,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] nommu: add anonymous page memcg accounting
Message-Id: <20101022133413.3ab2df01.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101022035302.GA15844@balbir.in.ibm.com>
References: <1287664088-4483-1-git-send-email-steve@digidescorp.com>
	<20101022035302.GA15844@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 09:23:03 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Steven J. Magnani <steve@digidescorp.com> [2010-10-21 07:28:08]:
> 
> > Add the necessary calls to track VM anonymous page usage (only).
> > 
> > V3 changes:
> > * Use vma->vm_mm instead of current->mm when charging pages, for clarity
> > * Document that reclaim is not possible with only anonymous page accounting
> >   so the OOM-killer is invoked when a limit is exceeded
> > * Add TODO to implement file cache (reclaim) support or optimize away
> >   page_cgroup->lru
> > 
> > V2 changes:
> > * Added update of memory cgroup documentation
> > * Clarify use of 'file' to distinguish anonymous mappings
> > 
> > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> BTW, I have no way of testing this, we need to rely on the NOMMU
> community to test this.
>  
Yes, that's the biggest problem.

-Kame

