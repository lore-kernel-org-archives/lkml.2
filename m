Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0EaXyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:54:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36038 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0EaXya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:54:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Jun 2010 08:50:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-Id: <20100601085006.f732c049.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100531135227.GC19784@uudg.org>
References: <20100528152842.GH11364@uudg.org>
	<20100528154549.GC12035@barrios-desktop>
	<20100528164826.GJ11364@uudg.org>
	<20100531092133.73705339.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikFk_HnZWPG0s_VrRkro2rruEc8OBX5KfKp_QdX@mail.gmail.com>
	<20100531140443.b36a4f02.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTil75ziCd6bivhpmwojvhaJ2LVxwEaEaBEmZf2yN@mail.gmail.com>
	<20100531145415.5e53f837.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTilcuY5e1DNmLhUWfXtiQgPUafz2zRTUuTVl-88l@mail.gmail.com>
	<20100531155102.9a122772.kamezawa.hiroyu@jp.fujitsu.com>
	<20100531135227.GC19784@uudg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 10:52:27 -0300
"Luis Claudio R. Goncalves" <lclaudio@uudg.org> wrote:

> | If an explanation as "acceralating all thread's priority in a process seems overkill"
> | is given in changelog or comment, it's ok to me.
> 
> If my understanding of badness() is right, I wouldn't be ashamed of saying
> that it seems to be _a bit_ overkill. But I may be wrong in my
> interpretation.
> 
> While re-reading the code I noticed that in select_bad_process() we can
> eventually bump on an already dying task, case in which we just wait for
> the task to die and avoid killing other tasks. Maybe we could boost the
> priority of the dying task here too.
> 
yes, nice catch.

Thanks,
-Kame

