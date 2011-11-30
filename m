Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1K3KOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:14:01 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50720 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1K3KN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:13:59 -0500
Date: Wed, 30 Nov 2011 15:43:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Heechul Yun <heechul@illinois.edu>
Cc: pjt@google.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] sched: Proper initialization of root_task_group
Message-ID: <20111130101338.GA4543@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20111130054227.GA7808@heechul-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111130054227.GA7808@heechul-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11113000-6102-0000-0000-0000004AD7E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heechul Yun <heechul@illinois.edu> [2011-11-29 23:42:29]:

> Hi,
> 
> The following patch fix a initialization issue.
> 
> Thanks
> 
> Heechul
> 
> ---
> The root_task_group.cfs_bandwidth and root_task_group.shares
> were initialized multiple times unnecessarily which are corrected
> by this patch.
> 
> Signed-off-by: Heechul Yun <heechul@illinois.edu>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>


Thanks,
Kamalesh.

