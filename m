Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0DORDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:03:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36695 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0DORDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:03:14 -0400
Date: Thu, 15 Apr 2010 10:03:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: WARNING: at kernel/lockdep.c:2696 lockdep_init_map+0xd2/0x108()
Message-ID: <20100415170311.GK2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1271271162.9281.1.camel@localhost>
 <20100415152429.GE2471@linux.vnet.ibm.com>
 <r2y8aa016e11004150917u865ce90nd6adb5e13a802cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2y8aa016e11004150917u865ce90nd6adb5e13a802cc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:17:18PM +0200, Dhaval Giani wrote:
> On Thu, Apr 15, 2010 at 5:24 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Apr 14, 2010 at 08:52:42PM +0200, Dhaval Giani wrote:
> >> Hi Peter,
> >>
> >> I seem to be hitting this on bootup on a recent-ish git kernel (post
> >> -rc4).
> >
> > Is this addressed by ebd09ec93c90c8ec571d7e166832fb1fc705bf5e?
> > (http://lkml.org/lkml/2010/4/6/62)
> >
> 
> That patch was already in my kernel. Jiri's patch though was the magic balm :-).

Good to hear that there was some magic balm to be had!  ;-)

							Thanx, Paul
