Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab0FQBzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:55:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47660 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298Ab0FQBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, balbir@in.ibm.com,
       oleg@redhat.com
In-Reply-To: <201006092141.o59LfGoM023295@imap1.linux-foundation.org>
References: <201006092141.o59LfGoM023295@imap1.linux-foundation.org>
Message-Id: <20100617102913.FB6C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      oom: sacrifice child with highest badness score for parent fix
> has been added to the -mm tree.  Its filename is
>      oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
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
> Subject: oom: sacrifice child with highest badness score for parent fix
> From: David Rientjes <rientjes@google.com>
> 
> Elaborate on the comment in oom_kill_process() so it's clear why a
> killable child with a different mm is sacrificied for its parent.
> 
> At the same time, rename auto variable `c' to "child" and move "cpoints"
> inside the list_for_each_entry() loop with a more descriptive name as akpm
> suggests.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



