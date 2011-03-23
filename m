Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab1CWPcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:32:09 -0400
Received: from kroah.org ([198.145.64.141]:33499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab1CWPcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:32:05 -0400
Date: Wed, 23 Mar 2011 08:08:52 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: andy.green@linaro.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323150852.GE6284@kroah.com>
References: <4D79F068.2080009@linaro.org>
 <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
 <4D89C618.1020608@linaro.org>
 <201103231132.02690.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103231132.02690.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:32:02AM +0100, Arnd Bergmann wrote:
> On Wednesday 23 March 2011, Andy Green wrote:
> > It's the case for even usbnet, which is using a broken heuristic to 
> > decide what to call the interface not even based on vid / pid.
> 
> I agree that the heuristics in usbnet is less than helpful here,
> which among other things leads people to mixing up the two problems
> of fixing the device naming and fixing the MAC address assignment.
> 
> Even though I know Greg disagrees, I'd still prefer sanitising the
> rules for the default device name that usbnet assigns.

I'm all for that, but recall, we can't because of previous
implementations and past history.  I.e. you will break working systems
if you do this.  So we are stuck with what we have at the moment, sorry.

thanks,

greg k-h
