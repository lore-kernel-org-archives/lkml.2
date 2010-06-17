Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0FQBv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:51:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47674 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305Ab0FQBvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, balbir@in.ibm.com,
       oleg@redhat.com
In-Reply-To: <201006092141.o59LfK2S023306@imap1.linux-foundation.org>
References: <201006092141.o59LfK2S023306@imap1.linux-foundation.org>
Message-Id: <20100617103034.FB72.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      oom: introduce find_lock_task_mm to fix mm false positives fix
> has been added to the -mm tree.  Its filename is
>      oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
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
> Subject: oom: introduce find_lock_task_mm to fix mm false positives fix
> From: David Rientjes <rientjes@google.com>
> 
> find_lock_task_mm() should be documented so that we clearly understand
> what it does and why we need it.
> 
> At the same time, remove a stale coment about dereferencing of a local
> variable "mm" in badness() which no longer exists and was removed when
> find_lock_task_mm() was added.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




