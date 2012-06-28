Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2F1ClG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:41:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48389 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751985Ab2F1ClF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:41:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZYxsytW8ZH4hwixwvkkQSRH3+C0zijRtMGRxU52
	sUhG9rx4Iuaz66
Message-ID: <1340851258.7382.29.camel@marge.simpson.net>
Subject: Re: Attaching a process to cgroups
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Alexey Vlasov <renton@renton.name>, linux-kernel@vger.kernel.org
Date: Thu, 28 Jun 2012 04:40:58 +0200
In-Reply-To: <20120627171044.GF2418@linux.vnet.ibm.com>
References: <20120619185856.GC31797@beaver>
	 <1340195298.15707.3.camel@marge.simpson.net>
	 <20120621075428.GE31797@beaver>
	 <1340266982.29752.37.camel@marge.simpson.net>
	 <20120626180620.GK2397@linux.vnet.ibm.com>
	 <1340781811.10881.70.camel@marge.simpson.net>
	 <20120627171044.GF2418@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 10:10 -0700, Paul E. McKenney wrote:

> I really did mean "remove".  Removing a synchronize_rcu() does result
> in a race, but often an extremely low-probability race.  So you can
> remove a synchronize_rcu() and get lucky for a long time, but sooner
> or later, something will explode.

Ah.  Android patches did "replace", and it still didn't take long at all
for bad luck to happen.. so "remove" for that particular instance would
probably result in "sooner" variety explosions :)

-Mike

