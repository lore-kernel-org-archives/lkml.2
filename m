Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860Ab0JZNE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:04:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49010 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab0JZNEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:04:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [resend][PATCH 3/4] move cred_guard_mutex from task_struct to signal_struct
Cc: kosaki.motohiro@jp.fujitsu.com, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20101025175113.963CCC9E3C@blackie.sf.frob.com>
References: <20101025174220.GA21375@redhat.com> <20101025175113.963CCC9E3C@blackie.sf.frob.com>
Message-Id: <20101026220314.B7DD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Oct 2010 22:04:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Except: I am not sure about -stable. At least, this patch should
> > not go into the <2.6.35 kernels, it relies on misc changes which
> > changed the scope of task->signal. Before 2.6.35 almost any user
> > of ->cred_guard_mutex can race with exit and hit ->signal == NULL.
> 
> I see no justification for a change like this in any -stable tree.  It's
> just a cleanup, right?  If it's a prerequisite for the fix we like for an
> "important" bug, then that's a different story.  In its own right, it's
> clearly not appropriate for backporting.

Because [4/4] depend on [3/4] and I hope to backport it. Do you dislike it
too?


Thanks.



