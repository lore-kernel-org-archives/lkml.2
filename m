Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1GLGjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:39:08 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:37457 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab1GLGjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:39:06 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jul 2011 02:39:06 EDT
Date: Tue, 12 Jul 2011 08:33:17 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1981046693.20110712083317@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        julie Sullivan <kernelmail.jms@gmail.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
In-Reply-To: <20110711193021.GA2996@dumpdata.com>
References: <20110710032510.GG6014@linux.vnet.ibm.com> <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com> <20110710171626.GK6014@linux.vnet.ibm.com> <20110710173530.GA16954@linux.vnet.ibm.com> <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com> <20110710214639.GP6014@linux.vnet.ibm.com> <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com> <20110710231449.GQ6014@linux.vnet.ibm.com> <20110711162450.GA22913@dumpdata.com> <20110711171337.GK2245@linux.vnet.ibm.com> <20110711193021.GA2996@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monday, July 11, 2011, 9:30:22 PM, you wrote:

>> 
>> Hmmm...  Does the stall repeat about every 3.5 minutes after the first stall?

> Starting Configure read-only root support...
> [   81.335070] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=60002 jiffies)
> [   81.335091] sending NMI to all CPUs:
> [  261.367071] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=240034 jiffies)
> [  261.367092] sending NMI to all CPUs:
> [  441.399066] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=420066 jiffies)
> [  441.399089] sending NMI to all CPUs:

>> 
>> One thing to try would be to disable CONFIG_RCU_FAST_NO_HZ.  I wouldn't
>> expect this to have any effect, but might be worth a try.  It is really

> Did not help.
>> intended for small battery-powered systems.
>> 

Just as a note, i'm also seeing some stalls from domU's running a 3.0-rc kernel from you master tree (about 2 week old).
But it seems the first occurrences are not as quick after being booted. Unfortunately i haven't got time to investigate more this week.

--
Sander


