Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2EUAtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 20:49:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:40079 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab2EUAtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 20:49:50 -0400
Message-ID: <1337561378.2458.3.camel@pasglop>
Subject: Re: [PATCH] cpuidle: (POWER) Replace pseries_notify_cpuidle_add
 call with a elegant notifier to fix lockdep problem in start_secondary
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 21 May 2012 10:49:38 +1000
In-Reply-To: <1337561221.2458.1.camel@pasglop>
References: <4FB64E9A.3060100@linux.vnet.ibm.com>
	 <1337561221.2458.1.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 10:47 +1000, Benjamin Herrenschmidt wrote:

> Any reason why you don't do cpuidle_disable_device() when the
> CPU is going offline and cpuidle_enable_device() when it's coming
> back ?
> 
> I'm applying the patch for now since it fixes a real problem but
> if the above makes sense, please send a followup fix.

No I'm not ... it's damaged in some odd ways (some whitespace
missing here or there among others). Please resend a fixed one.

Cheers,
Ben.


