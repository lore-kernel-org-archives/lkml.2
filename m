Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab1IMEHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 00:07:00 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39937 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab1IMEG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 00:06:59 -0400
Date: Mon, 12 Sep 2011 21:06:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Temporary -rcu tree location
Message-ID: <20110913040647.GC2313@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110913000107.GA15945@linux.vnet.ibm.com>
 <alpine.LRH.2.00.1109130210090.19238@twin.jikos.cz>
 <20110913002419.GN2362@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1109130242440.13109@pobox.suse.cz>
 <20110913013400.GB2313@linux.vnet.ibm.com>
 <20110913120716.1b893c483ee91d6b7f12a5b4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913120716.1b893c483ee91d6b7f12a5b4@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 12:07:16PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> On Mon, 12 Sep 2011 18:34:00 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >
> > > there doesn't seem to be 'rcu/next' branch, right?
> > 
> > No, there is not.  So the idea is to push "rcu/next" the first time,
> > then ":rcu/next" thereafter?
> 
> Can't you just do a (forced) push over and over again without removing
> the branch each time?

I will give it a try on the next update.  ;-)

							Thanx, Paul
