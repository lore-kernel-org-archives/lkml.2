Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab0FQBzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:55:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47687 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0FQBvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + oom-fold-__out_of_memory-into-out_of_memory.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <201006112029.o5BKThHr017831@imap1.linux-foundation.org>
References: <201006112029.o5BKThHr017831@imap1.linux-foundation.org>
Message-Id: <20100617103122.FB78.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The patch titled
>      oom: fold __out_of_memory into out_of_memory
> has been added to the -mm tree.  Its filename is
>      oom-fold-__out_of_memory-into-out_of_memory.patch
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
> Subject: oom: fold __out_of_memory into out_of_memory
> From: David Rientjes <rientjes@google.com>
> 
> __out_of_memory() only has a single caller, so fold it into
> out_of_memory() and add a comment about locking for its call to
> oom_kill_process().
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


