Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1LSGIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:08:00 -0500
Received: from ozlabs.org ([203.10.76.45]:55945 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1LSGH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:07:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: paulmck@linux.vnet.ibm.com
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 10/15] module_param: make bool parameters really bool (core code)
In-Reply-To: <20111216195830.GH2419@linux.vnet.ibm.com>
References: <87k45ysf1n.fsf@rustcorp.com.au> <20111216195830.GH2419@linux.vnet.ibm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 19 Dec 2011 12:50:59 +1030
Message-ID: <87ty4xnvxw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 11:58:30 -0800, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Dec 15, 2011 at 01:43:24PM +1030, Rusty Russell wrote:
> > module_param(bool) used to counter-intuitively take an int.  In
> > fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> > trick.
> > 
> > It's time to remove the int/unsigned int option.  For this version
> > it'll simply give a warning, but it'll break next kernel version.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> For the rcutorture component:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Given that this portion of the patch is self-sufficient, I have queued
> the rcutorture portion of this patch with your signed-off-by, which I
> can push for either 3.3 or 3.4 (default is most likely 3.4).  Of course,
> if you would prefer some other approach, please let me know.

Nope, more than happy.  Have removed it from my patch.

Cheers,
Rusty.
