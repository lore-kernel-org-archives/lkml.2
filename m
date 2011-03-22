Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1CVNcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:32:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40828 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754189Ab1CVNcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:32:13 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+gpLIctoqg0EL5MlikywAVzFAreAfq9R80KVxEHH
	k9/mS22/L0CeFT
Date: Tue, 22 Mar 2011 14:32:08 +0100
From: torbenh <torbenh@gmx.de>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] RFC genirq: Add IRQ timestamping
Message-ID: <20110322133208.GB5507@siel.b>
Mail-Followup-To: john stultz <johnstul@us.ibm.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
 <AANLkTikt95R5DT3cTkPbTia9PpJqUr55v_g_xVN_AQtf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikt95R5DT3cTkPbTia9PpJqUr55v_g_xVN_AQtf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 07:33:26PM -0700, john stultz wrote:
> On Mon, Mar 21, 2011 at 4:59 AM, Torben Hohn <torbenh@gmx.de> wrote:
> > +       if (desc->status & IRQ_TIMESTAMP)
> > +               getrawmonotonic(&desc->last_timestamp);
> > +
> 
> I suspect you probably want some very clear comments around why you
> chose timestamps based on CLOCK_MONOTONIC_RAW instead of
> CLOCK_MONOTONIC. Likely in the code as well as in the commit log.

I really dont know which clock would be the most useful one.
CLOCK_MONOTONIC_RAW seems to be more suitable to drive dlls.
But the network layer probably wants CLOCK_MONOTONIC or
even CLOCK_REALTIME.

I didnt put much thought in this point, because it requires a broader
discussion, I think.

> 
> thanks
> -john

-- 
torben Hohn
