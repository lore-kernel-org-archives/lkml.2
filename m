Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2BBP4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:56:46 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45603 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab2BBP4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:56:44 -0500
Date: Thu, 2 Feb 2012 07:56:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC tip/core/rcu 10/41] ipv4: Convert call_rcu() to
 kfree_rcu()
Message-ID: <20120202155612.GG2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-10-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202002403.GB29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202002403.GB29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020215-7408-0000-0000-00000258EAF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:24:03PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:28AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The call_rcu() in do_ip_setsockopt() invokes opt_kfree_rcu(), which just
> > calls kfree().  So convert the call_rcu() to kfree_rcu(), which allows
> > opt_kfree_rcu() to be eliminated.
> 
> This and patch 9/41 have exactly the same subject line.  Consider
> adding the name of the function you replaced to each one, to
> disambiguate them.

Good point, will also add function names to the other three kfree_rcu()
patches.

							Thanx, Paul

