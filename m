Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0IWWMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:12:55 -0400
Received: from www.tglx.de ([62.245.132.106]:34859 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0IWWMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:12:54 -0400
Date: Fri, 24 Sep 2010 00:12:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Richard Cochran <richardcochran@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linuxppc-dev@lists.ozlabs.org,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/8] posix clocks: introduce a syscall for clock
 tuning.
In-Reply-To: <1285279423.5158.20.camel@pasglop>
Message-ID: <alpine.LFD.2.00.1009240008390.2416@localhost6.localdomain6>
References: <cover.1285261533.git.richard.cochran@omicron.at>  <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at> <1285279423.5158.20.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010, Benjamin Herrenschmidt wrote:
> On Thu, 2010-09-23 at 19:31 +0200, Richard Cochran wrote:
> > The new syscall, clock_adjtime, takes two parameters, the clock ID,
> > and a pointer to a struct timex. The semantics of the timex struct
> > have been expanded by one additional mode flag, which allows an
> > absolute offset correction. When specificied, the clock offset is
> > immediately corrected by adding the given time value to the current
> > time value.
> 
> Any reason why you CC'ed device-tree discuss ?
> 
> This list is getting way too much unrelated stuff, which I find
> annoying, it would be nice if we were all a bit more careful here with
> our CC lists.

Says the guy who missed to trim the useless context of the original
mail, which made me scroll down all the way just to find out that
there is nothing to see.

Thanks,

	tglx
