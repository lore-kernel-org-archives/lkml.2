Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0IPG5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:57:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48456 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0IPG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:57:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/4] oom: remove totalpage normalization from oom_badness()
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        Brad Spengler <spender@grsecurity.net>, Eugene Teo <eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1009152300380.25200@chino.kir.corp.google.com>
References: <20100916145452.3BB1.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009152300380.25200@chino.kir.corp.google.com>
Message-Id: <20100916155413.3BC0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Sep 2010 15:57:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 16 Sep 2010, KOSAKI Motohiro wrote:
> 
> > Current oom_score_adj is completely broken because It is strongly bound
> > google usecase and ignore other all.
> > 
> 
> We've talked about this issue three times already.  The last two times 
> you've sent a revert patch, you failed to followup on the threads:
> 
> 	http://marc.info/?t=128272938200002
> 	http://marc.info/?t=128324705200002
> 
> And now you've gone above Andrew, who is the maintainer of this code, and 
> straight to Linus.  Between that and your failure to respond to my answers 
> to your questions, I'm really stunned at how unprofessional you've handled 
> this.

Selfish must die. you failed to persuade to me. and I havgen't get anyone's objection.
Then, I don't care your ugly whining.



