Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991Ab2CNMks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:40:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33380 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760962Ab2CNMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:40:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX197icpoZlB7YXpJNJgw/7i5XNjupg9jdpJBRyrXOQ
	k4u8CstPoJtyGp
Message-ID: <1331728841.7465.7.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: sivanich@sgi.com, linux-kernel@vger.kernel.org
Date: Wed, 14 Mar 2012 13:40:41 +0100
In-Reply-To: <1331717099.5752.15.camel@marge.simpson.net>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
	 <1331717099.5752.15.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 10:24 +0100, Mike Galbraith wrote: 
> On Tue, 2012-03-13 at 17:24 -0700, Paul E. McKenney wrote: 
> > The following builds, but is only very lightly tested.  Probably full
> > of bug, especially when exercising CPU hotplug.
> 
> You didn't say RFT, but...
> 
> To beat on this in a rotund 3.0 kernel, the equivalent patch would be
> the below?  My box may well answer that before you can.. hope not ;-)

(Darn, it did.  Box says boot stall with virgin patch in tip too though.
Wedging it straight into 3.0 was perhaps a tad premature;)

