Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2IMQIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:08:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:30851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab2IMQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:08:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,417,1344236400"; 
   d="scan'208";a="203097802"
Subject: Re: [PATCH 0/3 v2] mm: Batch page reclamation under shink_page_list
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@intel.com>, Fengguang Wu <fengguang.wu@intel.com>
In-Reply-To: <20120911053657.GC14494@bbox>
References: <1347293960.9977.70.camel@schen9-DESK>
	 <20120911053657.GC14494@bbox>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Sep 2012 09:08:50 -0700
Message-ID: <1347552530.9977.101.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 14:36 +0900, Minchan Kim wrote:

> 
> If you send next versions, please use git-format-patch --thread style.
> Quote from man
> "       If given --thread, git-format-patch will generate In-Reply-To and References
>        headers to make the second and subsequent patch mails appear as replies to the
>        first mail; this also generates a Message-Id header to reference.
> "
> 
> It helps making your all patches in this series thread type in mailbox
> so reviewers can find all patches related to a subject easily.
> 

Thanks for your detailed review of the patch series.  Will incorporate
your suggestions on the next version.

Tim

