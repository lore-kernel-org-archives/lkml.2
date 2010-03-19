Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0CSBXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:23:21 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43070 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0CSBXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:23:20 -0400
Date: Fri, 19 Mar 2010 01:22:33 +0000
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: munroesj@us.ibm.com, Andreas Schwab <schwab@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ulrich Drepper <drepper@redhat.com>,
       David Miller <davem@davemloft.net>, ralf@linux-mips.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org
Subject: Re: 64-syscall args on 32-bit vs syscall()
Message-ID: <20100319012232.GA14108@shareable.org>
References: <4BA06E1B.2040706@redhat.com> <1268816179.2335.187.camel@pasglop> <4BA11FD2.2090104@zytor.com> <1268858134.2335.198.camel@pasglop> <4BA1412C.6070008@zytor.com> <1268866720.2335.204.camel@pasglop> <1268928480.19726.123.camel@spokane1.rchland.ibm.com> <m37hp9y51p.fsf@hase.home> <1268931823.19726.127.camel@spokane1.rchland.ibm.com> <1268947102.2335.236.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268947102.2335.236.camel@pasglop>
>From: Jamie Lokier <jamie@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jamie Lokier <jamie@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2010-03-18 at 12:03 -0500, Steven Munroe wrote:
> > Sorry in and long are compatible in 32-bit but not long long.
> > 
> > int and long are not compatible in 64-bit
> > 
> > It is hard the keep all the nodes and arguments straight.
> > 
> > But the concern about changing the prototype and are people actually
> > using the prototype are still valid.
> 
> Well, using the macro trick instead would fix that problem, code
> wouldn't build if it doesn't include unistd.h :-)

Or it will build, but call the old ABI version - no change to those programs.

-- Jamie
