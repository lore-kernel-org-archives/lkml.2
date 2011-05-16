Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab1EPHKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:10:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1EPHK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:10:29 -0400
Date: Mon, 16 May 2011 09:10:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516071019.GD24836@elte.hu>
References: <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <4DCC894D.3070204@kernel.org>
 <20110513084253.GE13647@elte.hu>
 <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513144059.GA32554@elte.hu>
 <20110513163801.GX2258@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513163801.GX2258@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Are you guys seeing NMIs at about the time the slowdown occurs?

None that produces a kernel message.

Also, the kernel config has:

 # CONFIG_LOCKUP_DETECTOR is not set
 # CONFIG_HARDLOCKUP_DETECTOR is not set
 # CONFIG_DETECT_HUNG_TASK is not set

So the NMI watchdog ought to be off. This system isnt producing spurious NMIs.

Thanks,

	Ingo
