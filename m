Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0KILBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:01:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48070 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab0KILBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:01:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        figo zhang <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com>
References: <1288834737.2124.11.camel@myhost> <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com>
Message-Id: <20101109195726.BC9E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 20:01:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 4 Nov 2010, Figo.zhang wrote:
> 
> > > > CAP_SYS_RESOURCE also had better get 3% bonus for protection.
> > > >
> > > 
> > > 
> > > Would you like to elaborate as to why?
> > > 
> > > 
> > 
> > process with CAP_SYS_RESOURCE capibility which have system resource
> > limits, like journaling resource on ext3/4 filesystem, RTC clock. so it
> > also the same treatment as process with CAP_SYS_ADMIN.
> > 
> 
> NACK, there's no justification that these tasks should be given a 3% 
> memory bonus in the oom killer heuristic; in fact, since they can allocate 
> without limits it is more important to target these tasks if they are 
> using an egregious amount of memory.  CAP_SYS_RESOURCE threads have the 
> ability to lower their own oom_score_adj values, thus, they should protect 
> themselves if necessary like everything else.

David, Stupid are YOU. you removed CAP_SYS_RESOURCE condition with ZERO
explanation and Figo reported a regression. That's enough the reason to
undo. YOU have a guilty to explain why do you want to change and why
do you think it has justification.

Don't blame bug reporter. That's completely wrong.




