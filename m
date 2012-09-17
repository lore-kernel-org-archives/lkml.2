Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2IQPmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:42:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35896 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2IQPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:42:21 -0400
Date: Mon, 17 Sep 2012 08:39:43 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH v7 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120917153943.GA7510@lizard>
References: <20120913150133.GA16238@lizard>
 <20120917113750.GA28838@kroah.com>
 <50571ADF.3000406@windriver.com>
 <20120917125427.GA23516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120917125427.GA23516@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 05:54:27AM -0700, Greg Kroah-Hartman wrote:
[...]
> > > To make it easier, can I just take the tty driver patches now?  Will
> > > that break anything?
> > 
> > I have not made my way through the entire series yet, so I am not sure
> > if you need the kdb header changes or not, but so far it looks like
> > the tty pieces are separate.  If you add your ack Greg, I'll take the
> > whole series and merge it into kgdb-next, or after I finish the review
> > we could do it the other way around.
> 
> Your tree is fine:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Let me know if you have problems merging this due to any tty patches,
> and if so, I'll be glad to take them through my tree.

Guys, thanks for taking a look into this!

The patch that adds nmi console driver (i.e. tty/serial/kgdb_nmi.c)
depends on the first KDB patches in these series, and it depends on
amba-pl1011 and tty_port work, which is in tty-next.

So, the series have to go via tty-next; I believe Jason won't able
to take it via his tree.

Thanks,

Anton.
