Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2HaMVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:21:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39271 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2HaMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:21:20 -0400
Date: Fri, 31 Aug 2012 13:25:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, "gregkh@suse.de" <gregkh@suse.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] hvc_dcc : add support to armv4 and armv5 core
Message-ID: <20120831132519.7c33f648@pyramind.ukuu.org.uk>
In-Reply-To: <5040A481.7020403@parrot.com>
References: <1346404916-27616-1-git-send-email-castet.matthieu@free.fr>
	<20120831110444.25d9b9fe@pyramind.ukuu.org.uk>
	<504091F0.1090703@parrot.com>
	<20120831103351.GE18957@n2100.arm.linux.org.uk>
	<20120831115939.23fd4a08@pyramind.ukuu.org.uk>
	<5040A481.7020403@parrot.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Then bury this crap in platform files please not in the drivers/tty layer
> > code. Make it a platform driver provided callback or something.
> > 
> I posted a new v2 patch that make the selection dynamic.

Thanks - fine with that one - or with burying it in headers etc in the arm
subdirs.

Greg's email address btw has changed - you want his current one as
suse.de bounces.

Alan
