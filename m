Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1GVO4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:56:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56396 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab1GVO4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:56:12 -0400
Date: Fri, 22 Jul 2011 07:56:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: rcu: Convert trivial uses of call_rcu() to kfree_rcu()
Message-ID: <20110722145604.GB2342@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711144643.GA4076@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1107221621010.7300@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107221621010.7300@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 04:21:47PM +0200, Jiri Kosina wrote:
> On Mon, 11 Jul 2011, Paul E. McKenney wrote:
> 
> > Hello, Jiri!
> > 
> > Does the patch below qualify as trivial?  If so, please feel free to
> > take it off my hands.  ;-)
> 
> Hi Paul!
> 
> normally that would qualify, yes. But I can see that it's already in 
> linux-next, so someone beat me picking it up (well, wasn't persumably too 
> hard in this case).

Hello, Jiri!

Indeed, Ingo said that he would pull it up through -tip.  Please accept
my apologies for the noise!

							Thanx, Paul
