Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2ASQim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:38:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2ASQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:38:39 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=v8bH6B52KJQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=HF70u1azpJzpN4Y6LUwA:9 a=Hi_-3DyZIYq759NPdvkA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326991117.17534.132.camel@gandalf.stny.rr.com>
Subject: Re: rt-kernel 3.0.14-rt31: BUG: sleeping function called from
 invalid context
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: Karsten Wiese <fzuuzf@googlemail.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 19 Jan 2012 11:38:37 -0500
In-Reply-To: <CAONaPpGHULxDZXBTprkCy9vKPH46gHOiQs6GM_ysfP2znDqqXg@mail.gmail.com>
References: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com>
	 <201201180053.52617.fzuuzf@googlemail.com>
	 <1326848525.17534.66.camel@gandalf.stny.rr.com>
	 <CAONaPpGHULxDZXBTprkCy9vKPH46gHOiQs6GM_ysfP2znDqqXg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 17:16 +0100, John Kacur wrote:

> I'm testing v3.0.14-rt32-rc1, and it greatly reduced the number of
> these, but I still got one during boot.
> 
> [   11.938649] BUG: sleeping function called from invalid context at
> /home/jkacur/rt.linux.git/kernel/rtmutex.c:645
> [   11.938651] in_atomic(): 1, irqs_disabled(): 1, pid: 168, name: irq/9-acpi
> [   11.938653] 1 lock held by irq/9-acpi/168:
> [   11.938653]  #0:  (acpi_gbl_gpe_lock){......}, at:
> [<ffffffff8123881d>] acpi_ev_gpe_detect+0x31/0x110

Could you test 3.2-rt. If that has the issue then we know we have more
to fix. If not, we know I missed a patch.

-- Steve


