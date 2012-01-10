Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2AJOXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:23:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:54324 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2AJOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:23:39 -0500
Date: Tue, 10 Jan 2012 15:23:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jonathan Nieder <jrnieder@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Phil Miller <mille121@illinois.edu>
Subject: Re: [27/27] clockevents: Set noop handler in
 clockevents_exchange_device()
In-Reply-To: <CA+55aFxzM0DamY13ZP_xnOzvcTfyyZtHFc8gismerqDVvGiuWA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1201101522590.3020@ionos>
References: <20111207165611.GA19872@kroah.com> <20111207165602.672902223@clark.kroah.org> <20111229120956.GA31878@elie.Belkin> <CA+55aFxzM0DamY13ZP_xnOzvcTfyyZtHFc8gismerqDVvGiuWA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1423828635-1326205416=:3020"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1423828635-1326205416=:3020
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 29 Dec 2011, Linus Torvalds wrote:

> On Thu, Dec 29, 2011 at 4:09 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> >
> > This is basically the reverse of 7c1e768974 (clockevents: prevent
> > clockevent event_handler ending up handler_noop, 2008-09-03).  The
> > rationale for the latter still applies.
> 
> Hmm. You seem to be right. Instead of applying this to stable, it
> looks like we should revert it from mainline.
> 
> >                  People have been reporting
> > the analagous patch to this one causing hangs on resume in 3.1.y and
> > 3.2 release candidates:
> >
> >  - http://thread.gmane.org/gmane.linux.kernel/1233033
> >  - http://thread.gmane.org/gmane.linux.kernel/1233389
> >  - http://thread.gmane.org/gmane.linux.kernel/1233159
> >  - http://thread.gmane.org/gmane.linux.kernel/1227868/focus=1230877
> >
> > So please consider reverting it for now.
> 
> Thomas? It does seem to be broken and there do seem to be regression
> reports about it.
> 
> Should I revert it, or do you have alternative fixes?

Hmm. I have no idea what broke. Will have a look.

Thanks,

	tglx
--8323328-1423828635-1326205416=:3020--
