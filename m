Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1FGXoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:44:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1FGXoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:44:00 -0400
Date: Wed, 8 Jun 2011 01:43:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] Fix mismatched variable in rcutree_trace.c
Message-ID: <20110607234356.GA27166@one.firstfloor.org>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org> <1307485593-27196-2-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1106080040320.11814@ionos> <20110607231306.GH2286@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607231306.GH2286@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm...  Some arches have signed CPU numbers while others have unsigned
> CPU numbers.  I do use "-1" to mean "no CPU" in some cases (for example,
> in rcu_node_kthread_setaffinity()), so I guess for consistency I should
> be using "int" everywhere.

Do I hear that "int" is ok for you? If yes I will not revise the patch
and please merge it.  If it needs changes please let me know.

-Andi
