Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1IMAY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 20:24:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:32879 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1IMAYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 20:24:22 -0400
Date: Mon, 12 Sep 2011 17:24:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Temporary -rcu tree location
Message-ID: <20110913002419.GN2362@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110913000107.GA15945@linux.vnet.ibm.com>
 <alpine.LRH.2.00.1109130210090.19238@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1109130210090.19238@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 02:11:05AM +0200, Jiri Kosina wrote:
> On Mon, 12 Sep 2011, Paul E. McKenney wrote:
> 
> > PS.  If someone knows how to make github delete a branch, please let me
> >      know, as this would allow me to use the "rcu/next" nomenclature.
> >      Yes, it is probably obvious, but I am new to github...
> 
> git push origin :branch should work everywhere, right?

Here is what happens when I try that:

	git push github :rcu/next
	Username: 
	Password: 
	error: unable to push to unqualified destination: rcu/next
	The destination refspec neither matches an existing ref on the remote nor
	begins with refs/, and we are unable to guess a prefix based on the source ref.
	error: failed to push some refs to 'https://github.com/paulmckrcu/linux'

So what am I missing here?

							Thanx, Paul
