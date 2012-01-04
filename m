Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2ADWYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:24:51 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49176 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757084Ab2ADWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:24:49 -0500
X-Sasl-enc: wUCYrdxG/SyBi1oH9WME5etbdjpldl25q8T7OyTLot5t 1325715888
Date: Wed, 4 Jan 2012 14:24:31 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Cox <alan@linux.intel.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/documentation: fix name of DCD cpp symbol
Message-ID: <20120104222431.GA23683@kroah.com>
References: <1322857211-26654-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20111202234248.373cfd4f@bob.linux.org.uk>
 <4F04DD19.1070602@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F04DD19.1070602@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 03:13:29PM -0800, Randy Dunlap wrote:
> On 12/02/2011 03:42 PM, Alan Cox wrote:
> > On Fri,  2 Dec 2011 21:20:11 +0100
> > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > 
> >> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >> ---
> >>  Documentation/serial/driver |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/Documentation/serial/driver b/Documentation/serial/driver
> >> index 77ba0af..0a25a91 100644
> >> --- a/Documentation/serial/driver
> >> +++ b/Documentation/serial/driver
> >> @@ -101,7 +101,7 @@ hardware.
> >>  	Returns the current state of modem control inputs.  The state
> >>  	of the outputs should not be returned, since the core keeps
> >>  	track of their state.  The state information should include:
> >> -		- TIOCM_DCD	state of DCD signal
> >> +		- TIOCM_CAR	state of DCD signal
> >>  		- TIOCM_CTS	state of CTS signal
> >>  		- TIOCM_DSR	state of DSR signal
> >>  		- TIOCM_RI	state of RI signal
> > 
> > Acked-by: Alan Cox <alan@linux.intel.com>
> > 
> > but please fix the Subject line to be less confusing - it sounds like
> > it changes the define not the docs... 
> 
> 
> (sorry for the delayed reply)
> 
> I thought that DCD meant Data Carrier Detect.  Is that old?  Has it changed
> to just Carrier?
> 
> Greg, do you want to merge this?

Sure, I can, care to bounce me the original?

greg k-h
