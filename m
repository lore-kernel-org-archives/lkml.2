Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0IILuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:50:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:57611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0IILud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:50:33 -0400
Subject: Re: cgroup: rmdir() does not complete
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Hills <mark@pogo.org.uk>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.NEB.2.01.1009091234230.26366@jrf.vwaro.pbz>
References: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
	 <20100827095639.6e7297de.nishimura@mxp.nes.nec.co.jp>
	 <20100827113506.2bbbb7b9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100827123948.b4427a15.nishimura@mxp.nes.nec.co.jp>
	 <20100827144225.3190167a.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.NEB.2.01.1009011200050.6596@jrf.vwaro.pbz>
	 <20100902084200.e9b773cf.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.NEB.2.01.1009091051400.17759@jrf.vwaro.pbz>
	 <20100909100909.GM4443@balbir.in.ibm.com>
	 <alpine.NEB.2.01.1009091234230.26366@jrf.vwaro.pbz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Sep 2010 13:50:17 +0200
Message-ID: <1284033017.402.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 12:36 +0100, Mark Hills wrote:

> I am still finding the problem incredibly hard to reproduce, so I'd like 
> to observe as much data as possible from the current case before 
> rebooting. If I could capture some kind of stack trace in the kernel for 
> the running process that would be great, any suggestions appreciated.

echo l > /proc/sysrq-trigger

another thing you can do is run something like: perf record -gp $pid
which will give you a profile of that task.
