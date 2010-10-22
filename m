Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0JVDxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:53:11 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43046 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0JVDxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:53:09 -0400
Date: Fri, 22 Oct 2010 09:23:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-mm@kvack.org, dhowells@redhat.com, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH V3] nommu: add anonymous page memcg accounting
Message-ID: <20101022035302.GA15844@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1287664088-4483-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1287664088-4483-1-git-send-email-steve@digidescorp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven J. Magnani <steve@digidescorp.com> [2010-10-21 07:28:08]:

> Add the necessary calls to track VM anonymous page usage (only).
> 
> V3 changes:
> * Use vma->vm_mm instead of current->mm when charging pages, for clarity
> * Document that reclaim is not possible with only anonymous page accounting
>   so the OOM-killer is invoked when a limit is exceeded
> * Add TODO to implement file cache (reclaim) support or optimize away
>   page_cgroup->lru
> 
> V2 changes:
> * Added update of memory cgroup documentation
> * Clarify use of 'file' to distinguish anonymous mappings
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

BTW, I have no way of testing this, we need to rely on the NOMMU
community to test this.
 

-- 
	Three Cheers,
	Balbir
