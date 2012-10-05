Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2JEL5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab2JEL5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:57:44 -0400
Date: Fri, 5 Oct 2012 13:57:31 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH 0/8] THP support for Sparc64
Message-ID: <20121005115731.GI6793@redhat.com>
References: <20121002155544.2c67b1e8.akpm@linux-foundation.org>
 <20121003.220027.1636081487098835868.davem@davemloft.net>
 <20121004103548.GB6793@redhat.com>
 <20121004.141136.1763670567147718953.davem@davemloft.net>
 <20121005092810.GA27763@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005092810.GA27763@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Fri, Oct 05, 2012 at 11:28:10AM +0200, Michal Hocko wrote:
> FWIW there is also a pure -mm (non-rebased) git tree at
> http://git.kernel.org/?p=linux/kernel/git/mhocko/mm.git;a=summary
> since-3.6 branch. It is based on top of 3.6 with mm patches from
> Andrew's tree.

I'd still suggest to use your mm.git tree to rebase the -mm patches,
until schednuma will be dropped from linux-next. Either that or I hope
you don't run any benchmark with more than one NUMA node.

Thanks,
Andrea
