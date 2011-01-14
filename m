Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1ANTUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:20:18 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46679 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1ANTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:20:16 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187J1XNfhRv7ga9Emk7/rv7
Date: Fri, 14 Jan 2011 11:19:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
Message-ID: <20110114191956.GK4957@atomide.com>
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
 <4CF5DD63.40803@codeaurora.org>
 <1291229696.14404.39.camel@c-dwalke-linux.qualcomm.com>
 <4CF6AE04.6030201@codeaurora.org>
 <4CFE86AC.9010801@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFE86AC.9010801@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Boyd <sboyd@codeaurora.org> [101207 11:00]:
> On 12/01/2010 12:20 PM, Stephen Boyd wrote:
> > Definitely for TX since it seems like a redundant loop, but I agree RX
> > code has changed. Instead of
> >
> > If RX buffer full
> > Poll for RX buffer full
> > Read character from RX buffer
> >
> > we would have
> >
> > If RX buffer full
> > Read character from RX buffer
> >
> > which doesn't seem all that different assuming the RX buffer doesn't go
> > from full to empty between the If and Poll steps. Hopefully Tony knows more.
> >
> 
> Tony, any thoughts?

Sorry for the delay, looks like I'm only 1 month behind with email..
Sounds like it should work to me. I can try it out if you point me
to a patch.

Regards,

Tony
