Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2FDKJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:09:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab2FDKJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:09:29 -0400
Date: Mon, 4 Jun 2012 13:09:25 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: automount hangs during boot somewhere in rcu_barrier.
Message-ID: <20120604100925.GC23670@redhat.com>
References: <20120603113236.GW2311@redhat.com>
 <20120604031549.GE2357@linux.vnet.ibm.com>
 <20120604074803.GA23670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604074803.GA23670@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:48:03AM +0300, Gleb Natapov wrote:
> On Sun, Jun 03, 2012 at 08:15:49PM -0700, Paul E. McKenney wrote:
> > Hmmm...  Could you please try disabling CONFIG_RCU_FAST_NO_HZ?  If that
> > makes the problem go away, I have some patches 3.6-targeted patches
> > for you.
> Will report back.
> 
Do not see any problems with the option disabled.

--
			Gleb.
