Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab0FUKOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:14:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab0FUKOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:14:30 -0400
Date: Mon, 21 Jun 2010 06:14:26 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Tilman Schmidt <tilman@imap.cc>,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PROVE_RCU breaks proprietary modules (rcu_lock_map)
Message-ID: <20100621101425.GA20317@bombadil.infradead.org>
References: <4BA689EA.4050102@imap.cc> <20100329150946.GB2569@linux.vnet.ibm.com> <4BB0E937.7070200@imap.cc> <20100329184059.GL2569@linux.vnet.ibm.com> <20100617103747.GZ20317@bombadil.infradead.org> <20100620151605.GA2396@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100620151605.GA2396@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 08:16:05AM -0700, Paul E. McKenney wrote:
> My kneejerk reaction is that PROVE_RCU is a developer tool, so I am
> OK with it not being set by default in Rawhide.  Or have you seen good
> value from (say) PROVE_LOCKING in Rawhide?
> 

Hi Paul,

I'm fine with this, we try to enable debug options in rawhide in order
to get the most out of bug reports/dmesgs that we can. We've definitely
spotted a lot of lockdep reports by having it enabled for general
desktop use cases (but as debugging has become more intensive, the perf
loss from having it enabled is more costly.)

I suspect we'll be OK with PROVE_RCU off though.

Thanks!

regards, Kyle
