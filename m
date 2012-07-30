Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2G3W2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:28:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2G3W2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:28:34 -0400
Date: Mon, 30 Jul 2012 15:28:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert
 "hugetlb: avoid taking i_mmap_mutex in unmap_single_vma() for hugetlb"
Message-Id: <20120730152832.f27152d0.akpm@linux-foundation.org>
In-Reply-To: <877gtp5dnr.fsf@skywalker.in.ibm.com>
References: <1343385965-7738-1-git-send-email-mgorman@suse.de>
	<1343385965-7738-2-git-send-email-mgorman@suse.de>
	<877gtp5dnr.fsf@skywalker.in.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 22:45:04 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> >
> > Unless Aneesh has another reason for the patch, it should be reverted
> > to preserve hugetlb page sharing locking.
> >
> 
> I guess we want to take this patch as a revert patch rather than
> dropping the one in -mm. That would help in documenting the i_mmap_mutex
> locking details in commit message. Or may be we should add necessary
> comments around the locking ?

Code comments would be better if possible - we shouldn't force people to
dig around in git history to understand small code snippets.
