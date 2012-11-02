Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2KBVVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:21:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56167 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2KBVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121102184132.GB3027@linux.vnet.ibm.com>
References: <20121031034552.GA1999@linux.vnet.ibm.com>
	<1351655191-2648-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<CAFTL4hwv6xTiMYMe7ZpYk1bkDVJiwk-DQAm1tRXDFD2OyO_W=A@mail.gmail.com>
	<20121102184132.GB3027@linux.vnet.ibm.com>
Date: Fri, 2 Nov 2012 22:21:07 +0100
Message-ID: <CAFTL4hy+LkqBsuf7_eBg+cEPn7yTJx_imXsZ-hunF7Z_ZLBdog@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Add callback-free CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu, patches@linaro.org, joe.korty@ccur.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/2 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> The no-callbacks CPU would execute its own callbacks only if the
> corresponding kthread happened to be executing on that CPU.
> If you wanted a given CPU to be completely free of callbacks,
> you would instead constrain the corresponding kthread to run
> elsewhere.

Ah ok, makes sense.

Thanks.
