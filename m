Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2GTJ2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:28:38 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:38729 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751438Ab2GTJ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:28:36 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2012 05:28:36 EDT
Message-ID: <1342775305.7432.76.camel@marge.simpson.net>
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
From: Mike Galbraith <mgalbraith@novell.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mmokrejs@fold.natur.cuni.cz, dan.carpenter@oracle.com
Date: Fri, 20 Jul 2012 11:08:25 +0200
In-Reply-To: <5009170E.1080807@linux.vnet.ibm.com>
References: <5008CBD4.6070907@linux.vnet.ibm.com>
	 <1342767624.7432.54.camel@marge.simpson.net>
	 <5009170E.1080807@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 16:30 +0800, Michael Wang wrote: 
> On 07/20/2012 03:00 PM, Mike Galbraith wrote:
> > On Fri, 2012-07-20 at 11:09 +0800, Michael Wang wrote: 
> >> Hi, Mike, Martin, Dan
> >>
> >> I'm currently taking an eye on the rcu stall issue which was reported by
> >> you in the mail:
> >>
> >> rcu: endless stalls
> >> 	From: Mike Galbraith
> >> linux-3.4-rc7: rcu_sched self-detected stall on CPU
> >> 	From: Martin Mokrejs
> >> RCU stalls in linux-next
> >> 	From: Dan Carpenter
> >>
> >> I try to reproduce the issue on my X86 server with 12 cpu
> > 
> > The 'endless stalls' box was 341.33333 times larger.  Dunno if you can
> > even set a serial port slow enough to approximate all cores trying to
> > gripe through a single pinhole simultaneously.
> 
> Hi, Mike
> 
> Thanks for your reply.
> 
> So you mean this issue is still existing on you box and you can see it
> without doing any special things?

It's not my box (thank god).  It was initially triggered by tasks
exiting simultaneously on all cores.  They jammed up, endless stall
followed.

> I just want to try to reproduce it but it's impossible for me to get
> some hardware as yours...
> 
> So is there any idea on how to reproduce it on normal hardware?

No, AFAIK this problem is restricted to size XXL boxen, with all the
joys that come along with having way too many CPUs.

-Mike

