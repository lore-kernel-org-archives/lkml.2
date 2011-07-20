Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1GTKuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:50:03 -0400
Received: from mail001.aei.ca ([206.123.6.130]:38837 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1GTKuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:50:02 -0400
From: Ed Tomlinson <edt@aei.ca>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads trainwreck
Date: Wed, 20 Jul 2011 06:49:57 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc7-crc+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, greearb@candelatech.com
References: <20110720001738.GA16369@linux.vnet.ibm.com> <201107192207.33813.edt@aei.ca> <20110720044435.GB2400@linux.vnet.ibm.com>
In-Reply-To: <20110720044435.GB2400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107200649.58956.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 July 2011 00:44:35 Paul E. McKenney wrote:
> On Tuesday 19 July 2011 20:17:38 Paul E. McKenney wrote:
> > 
> > Paul,
> > 
> > Two things to add.  Its possible an eariler error is missing from the log below.  My serial console was missing
> > entries from before '0 and 40ish' and I did think I saw a bunch of FFFFFFFs scroll by eariler...
> > 
> > Second, booting with threadirqs and boost enabled in .config with patches 2,5,6 is ok so far.
> 
> Patches 3 and 4 resulted in failures?  (Patch 1 certainly did.)

I tried with all 7 and got an unstable system.  decided to add use the two I had already tested and
add one at a time.  Things seem ok with 2 (fix boost).  I've not tried with 2, 3,4,5,6.  Given that you
have changed patch 1, I'll reboot with all 7 again.

Ed
