Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2FNVeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:34:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43031 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751175Ab2FNVeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:34:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18SWTRTa4sS2SUVxqO9+s/cvxSU4jsDyk1s8wilA9
	ELlqIdhADqZx9X
Message-ID: <1339709659.7488.150.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Jun 2012 23:34:19 +0200
In-Reply-To: <20120614164746.GG2458@linux.vnet.ibm.com>
References: <20120611133953.GI2425@linux.vnet.ibm.com>
	 <1339424543.7350.101.camel@marge.simpson.net>
	 <1339435214.7358.43.camel@marge.simpson.net>
	 <20120611180112.GD2521@linux.vnet.ibm.com>
	 <1339438242.7358.62.camel@marge.simpson.net>
	 <1339558508.7472.26.camel@marge.simpson.net>
	 <alpine.LSU.2.00.1206122120460.5221@eggly.anvils>
	 <1339566974.7472.45.camel@marge.simpson.net>
	 <1339571575.7472.78.camel@marge.simpson.net>
	 <1339659932.7347.76.camel@marge.simpson.net>
	 <20120614164746.GG2458@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 09:47 -0700, Paul E. McKenney wrote: 
> On Thu, Jun 14, 2012 at 09:45:32AM +0200, Mike Galbraith wrote:
> > Crickets chirping.. I know what _that_ means: "tsk tsk, you dummy" :)
> 
> In my case, it means that I suspect you would rather me continue working
> on my series of patches to further reduce RCU grace-period-initialization
> latencies on large systems than worry about this patch.

Well of course you, being vastly more qualified (duh), doing that
instead of me doing that is highly desirable, but no, I'm not into
slavery, either expressed or implied, so if it happens before I get to
poking at it again, great, if not, oh well.

Really, I don't care.  I trivially fixed the regression.  The folks who
need this are highly capable of piddling with it, and you know who they
are.  They ain't doing shit but trying to milk _me_ like a damn cow, so
I can't be arsed to give a shit, I'm way too busy to have that luxury.

-Mike

