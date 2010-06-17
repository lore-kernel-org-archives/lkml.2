Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab0FQBvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:51:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34321 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab0FQBvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, balbir@in.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com
In-Reply-To: <201006082350.o58NovSr032191@imap1.linux-foundation.org>
References: <201006082350.o58NovSr032191@imap1.linux-foundation.org>
Message-Id: <20100617102532.FB60.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      oom: check PF_KTHREAD instead of !mm to skip kthreads
> has been added to the -mm tree.  Its filename is
>      oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: oom: check PF_KTHREAD instead of !mm to skip kthreads
> From: Oleg Nesterov <oleg@redhat.com>
> 
> select_bad_process() thinks a kernel thread can't have ->mm != NULL, this
> is not true due to use_mm().
> 
> Change the code to check PF_KTHREAD.
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



