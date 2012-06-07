Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab2FGWbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:31:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48292 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab2FGWbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:31:17 -0400
Date: Thu, 7 Jun 2012 23:31:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brown <davidb@codeaurora.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: Tree for Jun 7 (fs / block / rcu)
Message-ID: <20120607223107.GA21150@sirena.org.uk>
References: <20120607131802.d90de854f06c5530c5fb2b33@canb.auug.org.au>
 <4FD0DD9F.5040206@xenotime.net>
 <20120607200007.GA3352@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607200007.GA3352@codeaurora.org>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 01:00:07PM -0700, David Brown wrote:
> On Thu, Jun 07, 2012 at 09:58:07AM -0700, Randy Dunlap wrote:

> net/built-in.o:/home/davidb/upstream/kdev/kernel/include/linux/rcupdate.h:312: more undefined references to `rcu_is_cpu_idle' follow

This is because rcu_is_cpu_idle() is only defined if PROVE_RCU but it's
used in a bunch of other cases.
