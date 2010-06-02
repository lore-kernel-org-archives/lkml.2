Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab0FBNyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:54:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab0FBNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:54:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] oom: select_bad_process: check PF_KTHREAD instead of !mm to skip kthreads
Cc: kosaki.motohiro@jp.fujitsu.com, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.2.00.1006011424200.16725@chino.kir.corp.google.com>
References: <20100601212023.GA24917@redhat.com> <alpine.DEB.2.00.1006011424200.16725@chino.kir.corp.google.com>
Message-Id: <20100602223612.F52D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Jun 2010 22:54:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 1 Jun 2010, Oleg Nesterov wrote:
> 
> > But yes, I agree, the problem is minor. But nevertheless it is bug,
> > the longstanding bug with the simple fix. Why should we "hide" this fix
> > inside the long series of non-trivial patches which rewrite oom-killer?
> > And it is completely orthogonal to other changes.
> > 
> 
> Again, the question is whether or not the fix is rc material or not, 
> otherwise there's no difference in the route that it gets upstream: the 
> patch is duplicated in both series.  If you feel that this minor issue 
> (which has never been reported in at least the last three years and 
> doesn't have any side effects other than a couple of millisecond delay 
> until unuse_mm() when the oom killer will kill something else) should be 
> addressed in 2.6.35-rc2, then that's a conversation to be had with Andrew.

Well, we have bugfix-at-first development rule. Why do you refuse our
development process?



