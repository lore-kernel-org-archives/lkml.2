Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2IQMye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 08:54:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab2IQMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:54:33 -0400
Date: Mon, 17 Sep 2012 05:54:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH v7 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120917125427.GA23516@kroah.com>
References: <20120913150133.GA16238@lizard>
 <20120917113750.GA28838@kroah.com>
 <50571ADF.3000406@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50571ADF.3000406@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 07:43:11AM -0500, Jason Wessel wrote:
> On 09/17/2012 06:37 AM, Greg Kroah-Hartman wrote:
> > On Thu, Sep 13, 2012 at 08:01:33AM -0700, Anton Vorontsov wrote:
> >> Hi all,
> >>
> >> Here comes the lucky v7:
> >>
> >> - Per Alan Cox's suggestion added hangup method and removed a small
> >>   leftover;
> >> - Per Colin Cross' suggestion moved IRQ quiescing logic into
> >>   poll_get_char routine. IIUC, Alan is less unhappy about it.  As a
> >>   result, clear_irq() callback dropped.
> >>
> >> These patches can be found in the following repo (based on tty-next):
> >>
> >> 	git://git.infradead.org/users/cbou/linux-nmi-kdb.git master
> >>
> >> Old changelogs and rationale for these patches can be found here:
> >>
> >> 	v1-v5, rationale: http://lkml.org/lkml/2012/9/10/2
> >> 	v6: http://lkml.org/lkml/2012/9/10/2
> > I have no objection to these patches, and as they are based on my
> > tty-next tree, should I be the ones accepting them?  If so, then I need
> > a bunch of acks from others involved in the kdb/kgdb code before I can
> > do so.
> >
> > To make it easier, can I just take the tty driver patches now?  Will
> > that break anything?
> 
> I have not made my way through the entire series yet, so I am not sure
> if you need the kdb header changes or not, but so far it looks like
> the tty pieces are separate.  If you add your ack Greg, I'll take the
> whole series and merge it into kgdb-next, or after I finish the review
> we could do it the other way around.

Your tree is fine:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Let me know if you have problems merging this due to any tty patches,
and if so, I'll be glad to take them through my tree.

greg k-h
