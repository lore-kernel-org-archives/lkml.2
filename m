Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0FTPQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 11:16:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48220 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab0FTPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 11:16:09 -0400
Date: Sun, 20 Jun 2010 08:16:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PROVE_RCU breaks proprietary modules (rcu_lock_map)
Message-ID: <20100620151605.GA2396@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BA689EA.4050102@imap.cc>
 <20100329150946.GB2569@linux.vnet.ibm.com>
 <4BB0E937.7070200@imap.cc>
 <20100329184059.GL2569@linux.vnet.ibm.com>
 <20100617103747.GZ20317@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617103747.GZ20317@bombadil.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 06:37:47AM -0400, Kyle McMartin wrote:
> On Mon, Mar 29, 2010 at 11:40:59AM -0700, Paul E. McKenney wrote:
> > > > I am comfortable with PROVE_RCU being incompatible with non-GPL modules.
> > > > After all, it is only a debugging option, not intended for production use.
> > > 
> > > I agree completely. I just wanted to publish that fact because it seems
> > > to be little known and can be quite a puzzler.
> > 
> > And I do very much appreciate your publicizing the solution!  ;-)
> > 
> 
> Hi Paul,
> 
> (Sorry I didn't bring this up until now.)
> 
> I don't really have any sympathy for people who use that crud, but from
> my POV it's going to generate some grief. Fedora builds rawhide with a
> lot of debugging options enabled in order to try and hit issues early
> before kernels release.
> 
> A few weeks ago, I noticed a report that PROVE_RCU was breaking some
> non-GPL junk. Digging a bit further, I noticed quite a number of more
> reports of this.
> 
> Is there any chances you could reconsider this? Otherwise I'll probably
> disable the option in Fedora's debug kernels as well if I continue to
> see confused users.

Hello, Kyle,

My kneejerk reaction is that PROVE_RCU is a developer tool, so I am
OK with it not being set by default in Rawhide.  Or have you seen good
value from (say) PROVE_LOCKING in Rawhide?

							Thanx, Paul
