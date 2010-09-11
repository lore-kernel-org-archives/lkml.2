Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0IKVVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 17:21:19 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48267 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752511Ab0IKVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 17:21:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] usbnet: do not count empty skbs as errors in rx_process()
Date: Sat, 11 Sep 2010 23:21:07 +0200
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <749423.9282.qm@web180313.mail.gq1.yahoo.com>
In-Reply-To: <749423.9282.qm@web180313.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009112321.10002.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 September 2010 23:15:29 David Brownell wrote:
> --- On Sat, 9/11/10, Ondrej Zary wrote:
> > Date: Saturday, September 11, 2010, 1:22 PM
> > On Saturday 11 September 2010
> >
> > 21:07:59 David Brownell wrote:
> > > NAK to this backwards-incompatible change.
> > >
> > > > This is needed for cx82310_eth.
>
> Backwards-incompatible changes are NOT "needed"
>
> > > I'd far rather see that driver fixed, than see
> > > the core usbnet framework broken to avoid such
> > > fixes to a very new driver ...
> >
> > I already tried to explain that the driver is not broken
>
> Yet you keep saying it doesn't work right, which
> is the classic definition of "broken, needs fix".
>
> > and so it cannot be
> > fixed. It's the way the hardware works and usbnet
> > is not > ready for it.
>
> And when we went over this before, I said how
> to resolve this:   a *BACKWARD-COMPATIBLE change
> that adds a new return state to rx_fixup(), used
> in the cx82310 code.  Why didn't you try that?

Something like the first patch that started this thread?

-- 
Ondrej Zary
