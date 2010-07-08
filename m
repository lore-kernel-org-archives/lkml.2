Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab0GHBLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:11:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53682 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0GHBLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:11:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: FYI: mmap_sem OOM patch
Cc: kosaki.motohiro@jp.fujitsu.com, Michel Lespinasse <walken@google.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>
In-Reply-To: <20100708084005.CD0F.A69D9226@jp.fujitsu.com>
References: <20100707231134.GA26555@google.com> <20100708084005.CD0F.A69D9226@jp.fujitsu.com>
Message-Id: <20100708100836.CD1A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Jul 2010 10:11:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yup.
> If admins want to kill memory hogging process manually when the system
> is under heavy swap thrashing, we will face the same problem, need 
> unfairness and fast exit. So, unfair exiting design looks very good.
> 
> If you will updated the description, I'm glad :)

I have one more topic. can we check fatal_signal_pending() instead TIF_MEMDIE?
As I said, if the process received SIGKILL, do the fork/exec/brk/mmap 
starvations have any problem?

Thanks.


