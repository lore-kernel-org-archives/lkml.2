Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2CaFyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 01:54:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54027 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2CaFyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 01:54:17 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND] gpio: add flags to export GPIOs when requesting
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Dong Aisheng-B29396 <B29396@freescale.com>
In-Reply-To: <20120330202900.GA15083@pengutronix.de>
References: <1323797641-7277-1-git-send-email-w.sang@pengutronix.de> <20120106152741.GE2610@pengutronix.de> <20120116163154.GF4223@ponder.secretlab.ca> <20120330202900.GA15083@pengutronix.de>
Date: Fri, 30 Mar 2012 23:54:13 -0600
Message-Id: <20120331055413.EF3BD3E0465@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 22:29:00 +0200, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Mon, Jan 16, 2012 at 09:31:54AM -0700, Grant Likely wrote:
> > On Fri, Jan 06, 2012 at 04:27:41PM +0100, Wolfram Sang wrote:
> > > On Tue, Dec 13, 2011 at 06:34:01PM +0100, Wolfram Sang wrote:
> > > > Introduce new flags to automatically export GPIOs when using the convenience
> > > > functions gpio_request_one() or gpio_request_array(). This eases support for
> > > > custom boards where lots of GPIOs need to be exported for customer
> > > > applications.
> > > > 
> > > > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > > > ---
> > > > 
> > > > Based on 3.2-rc5. Previous discussion (with kind of acks) can be found here
> > > > 
> > > > http://lkml.org/lkml/2011/11/15/378
> > > 
> > > Ping. I am using this patch with v3.2 right now and it is really useful
> > > (and no build failure this time (I owe you a drink for my last patch!))
> > 
> > Applied, thanks.
> 
> Has it been missed? I don't see it in linus-tree or your gpio-next?

Hmmm.  I don't know how, but I appear to have dropped this patch.  :-(
It didn't get any linux-next exposure so it will have to wait for
v3.5.  Sorry about this.  I have picked it up again and it will appear
in my gpio/next branch after the merge window closes.

g.

