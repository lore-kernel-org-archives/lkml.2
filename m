Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565Ab2EQWoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:44:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48311 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030492Ab2EQWom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:44:42 -0400
Date: Thu, 17 May 2012 15:43:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
Message-ID: <20120517224358.GQ2567@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120517221217.GA12196@linux.vnet.ibm.com>
 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337293651.4281.114.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337293651.4281.114.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051722-1780-0000-0000-000005AC868D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000275; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00140068; UDB=6.00032442; UTC=2012-05-17
 22:44:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 12:27:31AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-17 at 15:12 -0700, Paul E. McKenney wrote:
> >         cnt += sprintf(&page[cnt],
> > -                      "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
> > -                      "rtmbe: %d rtbke: %ld rtbre: %ld "
> > -                      "rtbf: %ld rtb: %ld nt: %ld "
> > -                      "onoff: %ld/%ld:%ld/%ld "
> > -                      "barrier: %ld/%ld:%ld",
> 
> The paranoid side of me would've used:
> 
> 	cnt += snprintf(page + cnt, PAGE_SIZE - cnt, ...);

OK, added to the todo list.  ;-)

							Thanx, Paul

