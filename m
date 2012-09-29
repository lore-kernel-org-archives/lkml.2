Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2I2VmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 17:42:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51892 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab2I2VmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 17:42:02 -0400
Date: Sat, 29 Sep 2012 14:41:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: eqs related warnings in linux-next
Message-ID: <20120929214151.GE2551@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50659D37.2020206@gmail.com>
 <20120928133633.GC12843@somewhere.redhat.com>
 <20120928173133.GB2498@linux.vnet.ibm.com>
 <50669952.1000805@gmail.com>
 <CAFTL4hzuh+iXPpKpyHWvpx3-Dwy9aq+poJLF_u=xcVfJPiaQVw@mail.gmail.com>
 <20120929133737.GB2551@linux.vnet.ibm.com>
 <506726AF.8040307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506726AF.8040307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092921-9360-0000-0000-00000B2D763F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 06:49:51PM +0200, Sasha Levin wrote:
> On 09/29/2012 03:37 PM, Paul E. McKenney wrote:
> > Sasha, is the easily reproducible?  If so, could you please try the
> > previous patch?  It will likely give us more information on where
> > this bug really lives.  (Yes, it might totally obscure the bug, but
> > in that case we will just need to try some other perturbation.)
> 
> Unlike the last issue, this one is *very* non-reproducible. In fact, I've only hit it once so far.

Wouldn't want it to be too easy, I guess...  ;-)

							Thanx, Paul

