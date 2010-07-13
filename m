Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0GMN61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 09:58:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:39610 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756760Ab0GMN6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 09:58:25 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18+9T9GKlA+nXZ4QYPCsmgnFUds/4gRAfjec18D4n
	fGJUsIZHiNjo3B
Date: Tue, 13 Jul 2010 17:00:21 +0300 (EEST)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: Dan Nicolaescu <dann@gnu.org>
Subject: emacs and "linux" coding style
Message-ID: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

according to Documentation/CodingStyle the "linux" style of emacs is 
broken because it uses tabs+spaces when continuing the argument list of a 
function on a new line. So I reported that as a bug to bug-gnu-emacs 
(bug#6617).

However it's not clear if this is a bug of emacs or an inconsistency of 
the linux kernel coding style. I can't find where exactly the usage *only* 
of tabs is mandated, see for example the following quote:


> Statements longer than 80 columns will be broken into sensible
> chunks. Descendants are always substantially shorter than the parent
> and are placed substantially to the right. The same applies to
> function headers with a long argument list. Long strings are as well
> broken into shorter strings. The only exception to this is where
> exceeding 80 columns significantly increases readability and does not
> hide information.


Tabs are not mentioned anywhere, besides the specific part about emacs 
which is so ironic that no emacs dev can read it fully. Moreover there are 
many parts in the kernel that are aligned using both tabs and spaces. 
Random example in the linux-2.6.34.1 kernel: kernel/sched.c


static void update_group_shares_cpu(struct task_group *tg, int cpu,
                                     unsigned long sd_shares,
                                     unsigned long sd_rq_weight,
                                     unsigned long *usd_rq_weight)
{


So what do you think? Should the current emacs "linux" style be fixed, or 
are spaces allowed?


Thanks,
Dimitris

