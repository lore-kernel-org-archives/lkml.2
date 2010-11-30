Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0K3VFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:05:14 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46870 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0K3VFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:05:11 -0500
Date: Tue, 30 Nov 2010 22:05:10 +0100
From: Andreas Mohr <andi@lisas.de>
To: Greg KH <gregkh@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, "David S. Miller" <davem@davemloft.net>,
        stable@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        dhollis@davehollis.com, Phil Chang <pchang23@sbcglobal.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -stable] Add USB PID for new MOSCHIP USB ethernet
 controller MCS7832 variant
Message-ID: <20101130210510.GA6057@rhlx01.hs-esslingen.de>
References: <20101130200737.GA5185@rhlx01.hs-esslingen.de>
 <20101130202712.GB16171@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20101130202712.GB16171@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 12:27:12PM -0800, Greg KH wrote:
> On Tue, Nov 30, 2010 at 09:07:37PM +0100, Andreas Mohr wrote:
> > Due to active notification of the new MCS7832 version by the manufacturer
> > today (Mr. Milton; thanks!) -- quote: "functionality same as MCS7830",
> > I'm now submitting this patch, intended for networking.git and -stable.
> 
> This is not how you get stuff into the stable kernel trees, sorry.
> Please read Documentation/stable_kernel_rules.txt for how to do that.

>From having read that perhaps 2 or 3 times (randomly)
and following a couple dozen -stable mails I had the impression that
remembering the constraints would be quite easy; obviously not - sorry!
Did have some doubts about the number of hunks, though.
And obviously violated the "must be upstream" rule.

So what to do?
Shovel patch as-is to networking only (optionally specifying the
somewhat unclearly formulated Cc: stable mechanism)?
Or rather minimalist-reduce the patch, then dito?

> Sometimes I wonder why we even write documentation if no one ever reads
> it...

I could also mention some (strangely familiar) cases where people _didn't_
write kernel docs which many people likely would have liked to read
to avoid wasting half-millions of dollars... *smirk*


Thanks,

Andreas Mohr
