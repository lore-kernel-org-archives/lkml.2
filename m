Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2HUJqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:46:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64157 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2HUJqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:46:07 -0400
Date: Tue, 21 Aug 2012 11:46:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, mingo@elte.hu, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/smphotplug] Fixes for Infiniband EHCA
Message-ID: <20120821094602.GA1705@gmail.com>
References: <20120820155754.GA20682@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820155754.GA20682@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Thomas,
> 
> This pair of patches fixes a typo and some warnings in the tip/smp/hotplug
> Infiniband patch.  They are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/smphotplug
> 
>   							Thanx, Paul
> 
> Paul E. McKenney (2):
>       infiniband: ehca: Fix while->do-while conversion typo
>       infiniband: ehca: Fix compiler warnings
> 
>  drivers/infiniband/hw/ehca/ehca_irq.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

Pulled, thanks Paul!

	Ingo
