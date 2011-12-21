Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1LUCrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:47:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42143 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1LUCrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:47:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 21 Dec 2011 11:46:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: hugetlb: fix pgoff computation when unmapping page
 from vma
Message-Id: <20111221114635.5b866875.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBDC9hxAFbbTvSWVa=t1kuyBH8=UoTYxRDtDm6iXLGkQWg@mail.gmail.com>
References: <CAJd=RBDC9hxAFbbTvSWVa=t1kuyBH8=UoTYxRDtDm6iXLGkQWg@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011 21:45:51 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> The computation for pgoff is incorrect, at least with
> 
> 	(vma->vm_pgoff >> PAGE_SHIFT)
> 
> involved. It is fixed with the available method if HPAGE_SIZE is concerned in
> page cache lookup.
> 
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

