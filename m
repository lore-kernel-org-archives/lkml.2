Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0DWDym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:54:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35660 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0DWDyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:54:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 23 Apr 2010 12:50:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg rcu lock fix in swap code (Was Re: [BUG]
 an RCU warning in memcg
Message-Id: <20100423125043.b3b964cd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4BD11A24.2070500@cn.fujitsu.com>
References: <4BD10D59.9090504@cn.fujitsu.com>
	<20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com>
	<4BD118E2.7080307@cn.fujitsu.com>
	<4BD11A24.2070500@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 11:55:16 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Li Zefan wrote:
> > KAMEZAWA Hiroyuki wrote:
> >> On Fri, 23 Apr 2010 11:00:41 +0800
> >> Li Zefan <lizf@cn.fujitsu.com> wrote:
> >>
> >>> with CONFIG_PROVE_RCU=y, I saw this warning, it's because
> >>> css_id() is not under rcu_read_lock().
> >>>
> >> Ok. Thank you for reporting.
> >> This is ok ? 
> > 
> > Yes, and I did some more simple tests on memcg, no more warning
> > showed up.
> > 
> 
> oops, after trigging oom, I saw 2 more warnings:
> 

ok, I will update.  thank you.


