Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1JRJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:25:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:40667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1JRJZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:25:57 -0400
Subject: Re: Scheduler BOF @ LinuxCon.EU/ELCE
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        rostedt <rostedt@goodmis.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 18 Oct 2011 11:25:34 +0200
In-Reply-To: <CAPM31RJ5nb4kk+7-d6cVoUfcZ_tUv+qnZ0JkWkQ9DHNinRM39Q@mail.gmail.com>
References: <1318872925.4172.81.camel@twins>
	 <CAPM31RJ5nb4kk+7-d6cVoUfcZ_tUv+qnZ0JkWkQ9DHNinRM39Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318929934.21167.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 02:16 -0700, Paul Turner wrote:

> Venki pointed out that there were a few talks at LPC regarding
> off-lining cores for power-saving.  We should try to provide some
> saner policy.

Yes, people using cpu hotplug for power management like that are insane
and should be taken out back and hugged,... by a grizzly bear.
