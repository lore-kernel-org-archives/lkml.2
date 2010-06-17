Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab0FQBvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:51:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34272 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab0FQBvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 6/9] oom: use same_thread_group instead comparing ->mm
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100616151547.GF9278@barrios-desktop>
References: <20100616203319.72E6.A69D9226@jp.fujitsu.com> <20100616151547.GF9278@barrios-desktop>
Message-Id: <20100617084452.FB39.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 16, 2010 at 08:34:02PM +0900, KOSAKI Motohiro wrote:
> > Now, oom are using "child->mm != p->mm" check to distinguish subthread.
> > But It's incorrect. vfork() child also have the same ->mm.
> > 
> > This patch change to use same_thread_group() instead.
> 
> Hmm. I think we don't use it to distinguish subthread. 
> We use it for finding child process which is not vforked. 
> 
> I can't understand your point. 

Thank you. my fault. respin.



