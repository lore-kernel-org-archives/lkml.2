Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab2IUXMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 19:12:17 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59827 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab2IUXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 19:12:15 -0400
Date: Sat, 22 Sep 2012 00:53:43 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120921225343.GA2938@electric-eye.fr.zoreil.com>
References: <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CBDF9.9020503@asyr.hopto.org> <20120921202957.GA32502@electric-eye.fr.zoreil.com> <505CD982.2000409@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505CD982.2000409@asyr.hopto.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> :
> on 09/21/2012 11:29 PM Francois Romieu wrote the following:
[...]
> What message? What do you mean "the usual netdev watchdog message"?

No, this one (see your 3.5.4 kernel log):

[   23.712058] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x121/0x1a3(
)
[   23.712062] Hardware name: AOA110
[   23.712067] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out

[...]
> > Could you perform a test with your vendor's 3.2-something kernel and its
> > r8169 driver ?
> > 
> The vendor's kernel was a 2.6 series.

You did experience a failure with a 3.5.4 kernel. Can you try a 3.2.x if
your vendor provides one ?

Thanks.

-- 
Ueimor
