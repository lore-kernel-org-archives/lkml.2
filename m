Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1ISLDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:03:08 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42841 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1ISLDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:03:06 -0400
Date: Mon, 19 Sep 2011 07:02:50 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: David Ward <david.ward@ll.mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110919110250.GA24550@hmsreliant.think-freely.org>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
 <CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
 <4E76864D.4080907@ll.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E76864D.4080907@ll.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: 0.2 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 08:01:17PM -0400, David Ward wrote:
> On 09/18/2011 02:06 PM, Linus Torvalds wrote:
> >2011/9/17 David Miller<davem@davemloft.net>:
> >>dpward (2):
> >>      net: Make flow cache namespace-aware
> >>      net: Handle different key sizes between address families in flow cache
> >>
> >>nhorman (1):
> >>      net: don't clear IFF_XMIT_DST_RELEASE in ether_setup
> >>
> >>rajan.aggarwal85@gmail.com (1):
> >>      net/can/af_can.c: Change del_timer to del_timer_sync
> >Guys, if somebody has such a broken email setup that they don't even
> >show their own name, don't take patches from them.
> 
> At least in my case, that is Patchwork's fault.  My name only
> started showing up like that in commits after I registered for an
> account (http://patchwork.ozlabs.org/register/), and I don't see any
> way to change the way my name appears in the Patchwork profile
> options.
> 
> The emails I sent to the netdev list showed my full name; see:
> http://marc.info/?l=linux-netdev&m=131527867326729&w=2
> http://marc.info/?l=linux-netdev&m=131527879226819&w=2
> 
I noticed this the other day when I registered as well.  Not sure what patchwork
is doing.
Neil

> David
> 


