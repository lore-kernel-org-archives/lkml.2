Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0HXWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:50:49 -0400
Received: from smtp-good-out-2.t-2.net ([84.255.208.44]:42446 "EHLO
	smtp-good-out-2.t-2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab0HXWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:50:45 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Greg KH <gregkh@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100824222035.GA10625@suse.de>
References: <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	 <1276291932.2154.45.camel@itpsd6lap>
	 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
	 <1277244410.2195.47.camel@itpsd6lap>
	 <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
	 <1277462596.2143.101.camel@itpsd6lap>
	 <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
	 <1282683470.8020.66.camel@itpsd6lap> <20100824211016.GA7176@suse.de>
	 <1282687797.8020.108.camel@itpsd6lap>  <20100824222035.GA10625@suse.de>
Content-Type: text/plain
Date: Wed, 25 Aug 2010 00:50:32 +0200
Message-Id: <1282690232.8020.116.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 24.08.2010 (tor) ob 15:20 -0700 je Greg KH zapisal(a):
> > > And what about the normal way of just writing to /dev/kmsg to do this?
> > > Why a whole new driver for this same functionality?
> > I must admit, i was not aware of the /dev/kmsg driver, but i made a few
> > tests and found out that it seems not to be possible to redirect console
> > to kmsg.
> 
> See how systemd does this, as it sounds like exactly what you want to
> do.  Look in either Fedora 14, or openSUSE Factory for examples of this,
> with no kernel changes needed.
> 
I'll check out systemd. 

however:)
It may be that systemd does not cover the initrd part of the
initialization and it may be an overkill do introduce systemd to an
existing system just to be analyzed.

regards, Samo

