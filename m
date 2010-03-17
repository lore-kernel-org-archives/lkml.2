Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0CQXw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:52:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35205 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0CQXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:52:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>, lee.schermerhorn@hp.com
Subject: Re: [PATCH 3/5] tmpfs: handle MPOL_LOCAL mount option properly
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       kiran@scalex86.org, cl@linux-foundation.org, mel@csn.ul.ie,
       stable@kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LSU.2.00.1003171619410.29003@sister.anvils>
References: <20100316145022.4C4E.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.1003171619410.29003@sister.anvils>
Message-Id: <20100318084915.8723.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 18 Mar 2010 08:52:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 16 Mar 2010, KOSAKI Motohiro wrote:
> 
> > commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
> > shmem_sb_info) added mpol=local mount option. but its feature is
> > broken since it was born. because such code always return 1 (i.e.
> > mount failure).
> > 
> > This patch fixes it.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> Thank you both for finding and fixing these mpol embarrassments.
> 
> But if this "mpol=local" feature was never documented (not even in the
> commit log), has been broken since birth 20 months ago, and nobody has
> noticed: wouldn't it be better to save a little bloat and just rip it out?

I have no objection if lee agreed, lee?
Of cource, if we agree it, we can make the new patch soon :)



