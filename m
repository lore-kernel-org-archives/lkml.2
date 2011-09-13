Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1IMBcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:32:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52537 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab1IMBct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:32:49 -0400
Date: Mon, 12 Sep 2011 18:32:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Temporary -rcu tree location
Message-ID: <20110913013243.GA2313@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110913000107.GA15945@linux.vnet.ibm.com>
 <20110913112127.cd62b006c302a575ceae4dee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913112127.cd62b006c302a575ceae4dee@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11091301-8974-0000-0000-000000192C22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 11:21:27AM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> On Mon, 12 Sep 2011 17:01:07 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Could you please make the -next tree pull from branch next.2011.09.12a
> > of https://github.com/paulmckrcu/linux while kernel.org is down?
> 
> I have swiched to that now (actually git://github.com/paulmckrcu/linux).
> Just a couple of minor changes and some new commits, right?  Hash of the
> branch top commit is f88a19a.

Yep, that is the one!  And yes, not hugely different than the last
rcu/next from the kernel.org -rcu, but Linus seemed to be rather serious
about pull requests having been exposed to -next testing.  ;-)

							Thanx, Paul

