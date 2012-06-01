Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724Ab2FASyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:54:53 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:59388 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626Ab2FASyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:54:51 -0400
Date: Fri, 1 Jun 2012 20:54:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        vapier@gentoo.org, konrad@gaisler.com, tkhai@yandex.ru,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 21/27] sparc32, smpboot: Use generic SMP booting
	infrastructure
Message-ID: <20120601185448.GA19148@merkur.ravnborg.org>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091503.31979.52537.stgit@srivatsabhat.in.ibm.com> <20120601.135612.699120609738854050.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601.135612.699120609738854050.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 01:56:12PM -0400, David Miller wrote:
> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Date: Fri, 01 Jun 2012 14:45:09 +0530
> 
> >  smp_do_cpu_idle:
> > -	call	cpu_idle
> >  	 mov	0, %o0
> 
> Just like the sparc64 patch, you need to remove the 'mov'

And the other callers of cpu_idle in the same file should
be updated/removed too.

There is one for sun4m, sun4d and leon.

	Sam
