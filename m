Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2FOHtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:49:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42844 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752460Ab2FOHtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:49:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/rK2ZadWvrozRrETLIEuNrFmixV5HwuZ+nOILx6G
	tPvDRuzFp/1APO
Message-ID: <1339746556.7316.13.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 15 Jun 2012 09:49:16 +0200
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

> In my case, it means that I suspect you would rather me continue working
> on my series of patches to further reduce RCU grace-period-initialization
> latencies on large systems than worry about this patch.

Hm, grumpy man may have misinterpreted that.  He's off for a weekend of
therapeutic bike riding and flower smelling in any case.

-Mike

