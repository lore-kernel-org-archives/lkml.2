Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2DEWch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:32:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25014 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2DEWcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:32:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 108.39.66.94
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19QlInoEEB6sMcTaME9YSz9jeQlolYNgU8=
Date: Thu, 5 Apr 2012 18:32:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH RFT v3] watchdog: Convert orion_wdt driver to watchdog
 core
Message-ID: <20120405223231.GK817@titan.lakedaemon.net>
References: <1332804040.5294.2.camel@phoenix>
 <20120331011432.GG7274@titan.lakedaemon.net>
 <CAF+7xWkuZ6q1TbWpdvwK57wGBwd_naVZsvtj0UackWWFcam7qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAF+7xWkuZ6q1TbWpdvwK57wGBwd_naVZsvtj0UackWWFcam7qw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 06:02:30PM +0800, Axel Lin wrote:
> 2012/3/31 Jason Cooper <jason@lakedaemon.net>:
> > On Tue, Mar 27, 2012 at 07:20:40AM +0800, Axel Lin wrote:
> >> Convert orion_wdt driver to use watchdog framework API.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >> ---
> >> Hi Jason, Andrew,
> >> I don't have this hardware handy.
> >> I'd appreciate if you can review and test this patch.
> >
> > Axel,
> >
> > Sorry for the delay, been a busy week.  I'm getting the following error:
> >
> > drivers/watchdog/orion_wdt.c:133:2: error: unknown field 'get_timeleft'
> > specified in initializer
> > drivers/watchdog/orion_wdt.c:133:2: warning: initialization from
> > incompatible pointer type
> >
> > What tag did you base this off of?  Are there any dependencies not in
> > mainline?
> I generate the patch base on linux-next tree.
> I just checked Linus' tree and this patch is appliable to Linus' tree.
> The required commit[1] is alread merged to Linus' tree now.
> Can you check it again?
> Thanks.

Ah, much better.  I rebased it against v3.4-rc1 now that it's out.
Compiles without problems.  I'll test this weekend most likely.  I don't
have my watchdog code in front of me atm.

thx,

Jason.

> [1] http://www.linux-watchdog.org/cgi-bin/gitweb.cgi?p=linux-watchdog.git;a=commitdiff;h=fd7b673c92731fc6c0b1e999adfd87b6762ee797
