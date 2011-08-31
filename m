Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1HaDrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 23:47:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43004 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751417Ab1HaDrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 23:47:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+v09Z8pD2vt5aH6xMY0nbkLgdQUeCFaC6ilDOe0V
	9VA9OrSQiJbAXx
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Mike Galbraith <efault@gmx.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20110830140648.GL9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	 <20110830140648.GL9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 05:47:22 +0200
Message-ID: <1314762442.4653.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 16:06 +0200, Frederic Weisbecker wrote:

> Ah I haven't tested with that isolcpus especially as it's headed toward
> removal.

It is?  Is it being replaced by something?  (I find it useful)

	-Mike


