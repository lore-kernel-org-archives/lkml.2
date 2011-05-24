Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1EXQwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:52:20 -0400
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:6453
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab1EXQwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:52:19 -0400
X-Trace: 383316144/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Evolution 2.32.2
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUAAOnh201TQwwf/2dsb2JhbAAMhFGTCMgnkHOBK4NpgQcElEWKXA
X-IronPort-AV: E=Sophos;i="4.65,261,1304290800"; 
   d="scan'208";a="383316144"
X-IP-Direction: IN
Subject: Re: [Bug #32202] 2.6.38 hangs on boot until key is pressed
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
In-Reply-To: <201105032356.48748.rjw@sisk.pl>
References: <QbBtx5c9v1J.A.JaF.PxGvNB@chimera>
	 <9nxEC7x0HFO.A.Q0F.txGvNB@chimera> <1304457036.17303.4.camel@deuteros>
	 <201105032356.48748.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 17:52:16 +0100
Message-ID: <1306255936.2573.0.camel@deuteros>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 23:56 +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 03, 2011, Tvrtko Ursulin wrote:
> > On Sat, 2011-04-30 at 22:17 +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.37 and 2.6.38.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> > > be listed and let the tracking team know (either way).
> > 
> > Hopefully reply to all count as letting you know "either way"?
> 
> It does, thanks for the update.
> 
> > Problem is still present in 2.6.38.5.
> 
> What about the mainline?

Seems to be gone in 2.6.39. Sorry but I had no time to test in the
meantime.

Thanks for tracking,

Tvrtko

