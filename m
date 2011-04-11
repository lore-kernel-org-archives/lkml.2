Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1DKELR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 00:11:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49631 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1DKELO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 00:11:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: mmotm 2011-03-31-14-48 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110403181147.AE42.A69D9226@jp.fujitsu.com>
References: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org> <20110403181147.AE42.A69D9226@jp.fujitsu.com>
Message-Id: <20110411131152.0069.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 11 Apr 2011 13:11:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The mm-of-the-moment snapshot 2011-03-31-14-48 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> 
> This doesn't boot.
> 
> =======================================================================
> [    0.169037] divide error: 0000 [#1] SMP
> [    0.169982] last sysfs file:
> [    0.169982] CPU 0
> [    0.169982] Modules linked in:
> [    0.169982]
> [    0.169982] Pid: 1, comm: swapper Not tainted 2.6.39-rc1-mm1+ #2 FUJITSU-SV      PRIMERGY                      /D2559-A1
> [    0.169982] RIP: 0010:[<ffffffff8104ad4c>]  [<ffffffff8104ad4c>] find_busiest_group+0x38c/0xd30

Please don't worry. This is not -mm problem. The breakage is in linus-tree.
Now fake numa feature doesn't work correctly and I and Tejun are discussing 
about a fix.




