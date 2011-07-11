Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab1GKTat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:30:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:56949 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1GKTas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:30:48 -0400
Date: Mon, 11 Jul 2011 15:30:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110711193021.GA2996@dumpdata.com>
References: <20110710032510.GG6014@linux.vnet.ibm.com>
 <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
 <20110710171626.GK6014@linux.vnet.ibm.com>
 <20110710173530.GA16954@linux.vnet.ibm.com>
 <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711171337.GK2245@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E1B4F63.00D7:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hmmm...  Does the stall repeat about every 3.5 minutes after the first stall?

Starting Configure read-only root support...
[   81.335070] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=60002 jiffies)
[   81.335091] sending NMI to all CPUs:
[  261.367071] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=240034 jiffies)
[  261.367092] sending NMI to all CPUs:
[  441.399066] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=420066 jiffies)
[  441.399089] sending NMI to all CPUs:

> 
> One thing to try would be to disable CONFIG_RCU_FAST_NO_HZ.  I wouldn't
> expect this to have any effect, but might be worth a try.  It is really

Did not help.
> intended for small battery-powered systems.
> 
