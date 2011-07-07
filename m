Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1GGU3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:29:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42091 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GGU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:29:06 -0400
From: julie Sullivan <kernelmail.jms@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Date: Thu, 7 Jul 2011 21:28:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4-revert+; KDE/4.6.2; x86_64; ; )
Cc: julie Sullivan <kernelmail.jms@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, torvalds@linux-foundation.org
References: <CAAVPGONLqy+gn_ggjQxyUoYifs4Hipcd-0t931w04StyrTCzxQ@mail.gmail.com> <201107072047.14429.kernelmail.jms@gmail.com> <20110707195845.GD6014@linux.vnet.ibm.com>
In-Reply-To: <20110707195845.GD6014@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072129.00324.kernelmail.jms@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What happens if you revert only these two?
> 
> f8b7fc6b514f34a51875dd48dff70d4d17a54f38 rcu: Move RCU_BOOST #ifdefs to header f
> a46e0899eec7a3069bcadd45dfba7bf67c6ed016 rcu: use softirq instead of kthreads ex
> 
> If that works, perhaps we should try to break down a46e0899ee into
> smaller pieces to see what is causing the trouble.
> 
> 								Thanx, Paul

I'll let you know as soon as the kernel is finished :-)
I'll look into the serial console but this is a laptop so I suppose I need to get my hands on
 a EHCI debug port or something that will work with one of the other ports.


