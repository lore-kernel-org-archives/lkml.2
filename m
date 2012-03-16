Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2CPTLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:11:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48352 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756269Ab2CPTLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:11:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+7DaRZHF676R/Nrxyz0J+7VHySqC5rQkmkT45kFW
	U3GuEB6x9dsKil
Message-ID: <1331925094.11723.11.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 20:11:34 +0100
In-Reply-To: <20120316172850.GC31290@sgi.com>
References: <1331728841.7465.7.camel@marge.simpson.net>
	 <20120314130801.GA11722@sgi.com> <20120314151717.GA2435@linux.vnet.ibm.com>
	 <20120314165657.GA19117@linux.vnet.ibm.com>
	 <1331779343.14263.6.camel@marge.simpson.net>
	 <1331780831.14263.15.camel@marge.simpson.net>
	 <20120315175933.GB8705@sgi.com>
	 <1331882861.11010.13.camel@marge.simpson.net>
	 <1331885384.11010.15.camel@marge.simpson.net>
	 <1331887535.11010.18.camel@marge.simpson.net>
	 <20120316172850.GC31290@sgi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 12:28 -0500, Dimitri Sivanich wrote:

> However, there are spinlock holdoffs at the following tracebacks (my nmi
> handler does work on the 3.0 kernel):

I'll try wedging/testing the subsequent patch Paul mentioned in both RT,
and NR_CPUS=max NOPREEMPT kernels.

-Mike

