Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2GTHAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:00:34 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:44450 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2GTHAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:00:33 -0400
Message-ID: <1342767624.7432.54.camel@marge.simpson.net>
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
From: Mike Galbraith <mgalbraith@novell.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mmokrejs@fold.natur.cuni.cz, dan.carpenter@oracle.com
Date: Fri, 20 Jul 2012 09:00:24 +0200
In-Reply-To: <5008CBD4.6070907@linux.vnet.ibm.com>
References: <5008CBD4.6070907@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 11:09 +0800, Michael Wang wrote: 
> Hi, Mike, Martin, Dan
> 
> I'm currently taking an eye on the rcu stall issue which was reported by
> you in the mail:
> 
> rcu: endless stalls
> 	From: Mike Galbraith
> linux-3.4-rc7: rcu_sched self-detected stall on CPU
> 	From: Martin Mokrejs
> RCU stalls in linux-next
> 	From: Dan Carpenter
> 
> I try to reproduce the issue on my X86 server with 12 cpu

The 'endless stalls' box was 341.33333 times larger.  Dunno if you can
even set a serial port slow enough to approximate all cores trying to
gripe through a single pinhole simultaneously.

-Mike

