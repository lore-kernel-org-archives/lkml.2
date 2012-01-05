Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2AEAZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:25:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:30874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456Ab2AEAZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:25:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103604258"
Date: Thu, 5 Jan 2012 00:37:53 +0000
From: Alan Cox <alan@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] serial/documentation: fix name of DCD cpp symbol
Message-ID: <20120105003753.1e6d2ed2@bob.linux.org.uk>
In-Reply-To: <4F04DD19.1070602@xenotime.net>
References: <1322857211-26654-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20111202234248.373cfd4f@bob.linux.org.uk>
	<4F04DD19.1070602@xenotime.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jan 2012 15:13:29 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 12/02/2011 03:42 PM, Alan Cox wrote:
> > On Fri,  2 Dec 2011 21:20:11 +0100
> > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > 
> >> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >> ---
> >>  Documentation/serial/driver |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/Documentation/serial/driver
> >> b/Documentation/serial/driver index 77ba0af..0a25a91 100644
> >> --- a/Documentation/serial/driver
> >> +++ b/Documentation/serial/driver
> >> @@ -101,7 +101,7 @@ hardware.
> >>  	Returns the current state of modem control inputs.  The
> >> state of the outputs should not be returned, since the core keeps
> >>  	track of their state.  The state information should
> >> include:
> >> -		- TIOCM_DCD	state of DCD signal
> >> +		- TIOCM_CAR	state of DCD signal
> >>  		- TIOCM_CTS	state of CTS signal
> >>  		- TIOCM_DSR	state of DSR signal
> >>  		- TIOCM_RI	state of RI signal
> > 
> > Acked-by: Alan Cox <alan@linux.intel.com>
> > 
> > but please fix the Subject line to be less confusing - it sounds
> > like it changes the define not the docs... 
> 
> 
> (sorry for the delayed reply)
> 
> I thought that DCD meant Data Carrier Detect.  Is that old?  Has it
> changed to just Carrier?

TIOCM_ are the kernel names. The documentation says we use TIOCM_DCD -
only we don't - the #define is TIOCM_CAR

So its a fix.
