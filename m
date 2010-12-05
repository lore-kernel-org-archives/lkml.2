Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0LEKDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 05:03:15 -0500
Received: from serv04.lahn.de ([213.239.197.57]:49909 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab0LEKDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 05:03:13 -0500
Date: Sun, 5 Dec 2010 10:55:28 +0100
From: Michael Leun <lkml20101129@newton.leun.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, Ben Greear <greearb@candelatech.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Gross <jesse@nicira.com>, stable@kernel.org
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not
 used
Message-ID: <20101205105528.49fa9a9f@xenia.leun.net>
In-Reply-To: <1291536233.2806.102.camel@edumazet-laptop>
References: <20101129201716.1d0257c4@xenia.leun.net>
	<4CF442FA.4070701@candelatech.com>
	<20101130095944.41b5f7b6@xenia.leun.net>
	<1291108809.2904.3.camel@edumazet-laptop>
	<20101201111716.424fb771@xenia.leun.net>
	<1291200914.2856.546.camel@edumazet-laptop>
	<20101205030712.36149bc2@xenia.leun.net>
	<1291536233.2806.102.camel@edumazet-laptop>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Dec 2010 09:03:53 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > But on
> > 
> > hpdl320g5:/home/ml # lspci | grep Eth
> > 03:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5714
> > Gigabit Ethernet (rev a3) 03:04.1 Ethernet controller: Broadcom
> > Corporation NetXtreme BCM5714 Gigabit Ethernet (rev a3)
> > 
> > the good message is that it also does not crash, but with tcpdump I
> > see vlan tags when no vlan devices configured on the respective
> > eth, if so I do not see tags anymore vlan tags on the trunk
> > interface.
> > 
> 
> For all these very specific needs, you'll have to try 2.6.37 I am
> afraid. Jesse did huge changes to exactly make this working, we wont
> backport this to 2.6.36, but only avoid crashes.

OK, I'm perfectly fine with that, of course, actually nice to hear that
the issue already is addressed.

Likely I'll give some rc an shot on this machine (maybe over christmas),
but it is an production machine (acutally testing other devices is the
"product" produced on this machine), so unfortunately I'm not that free
in when and what I can do (but the possibility to, for example, bridge
the trunk interface would make testing easier, that justifies
something...).

Thank you all very much for your work.


-- 
MfG,

Michael Leun

