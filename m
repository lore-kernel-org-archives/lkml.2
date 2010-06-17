Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0FQKhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 06:37:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0FQKhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 06:37:50 -0400
Date: Thu, 17 Jun 2010 06:37:47 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PROVE_RCU breaks proprietary modules (rcu_lock_map)
Message-ID: <20100617103747.GZ20317@bombadil.infradead.org>
References: <4BA689EA.4050102@imap.cc> <20100329150946.GB2569@linux.vnet.ibm.com> <4BB0E937.7070200@imap.cc> <20100329184059.GL2569@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329184059.GL2569@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 11:40:59AM -0700, Paul E. McKenney wrote:
> > > I am comfortable with PROVE_RCU being incompatible with non-GPL modules.
> > > After all, it is only a debugging option, not intended for production use.
> > 
> > I agree completely. I just wanted to publish that fact because it seems
> > to be little known and can be quite a puzzler.
> 
> And I do very much appreciate your publicizing the solution!  ;-)
> 

Hi Paul,

(Sorry I didn't bring this up until now.)

I don't really have any sympathy for people who use that crud, but from
my POV it's going to generate some grief. Fedora builds rawhide with a
lot of debugging options enabled in order to try and hit issues early
before kernels release.

A few weeks ago, I noticed a report that PROVE_RCU was breaking some
non-GPL junk. Digging a bit further, I noticed quite a number of more
reports of this.

Is there any chances you could reconsider this? Otherwise I'll probably
disable the option in Fedora's debug kernels as well if I continue to
see confused users.

--Kyle
