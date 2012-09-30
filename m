Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2I3MbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 08:31:02 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47105 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab2I3MbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 08:31:00 -0400
Date: Sun, 30 Sep 2012 14:30:54 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 080/262] usb: gadget: dummy_hcd: fixup error probe path
Message-ID: <20120930123054.GA4121@breakpoint.cc>
References: <20120928182957.993484211@linuxfoundation.org>
 <20120928183007.576522849@linuxfoundation.org>
 <1348945275.18878.32.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348945275.18878.32.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 09:01:15PM +0200, Ben Hutchings wrote:
> > This is a problem since 448b6eb1 ("USB: Make sure to fetch the BOS desc
> > for roothubs.) if used in USB3 mode because dummy does not provide this
> > descriptor and explodes later.
> [...]
> 
> i.e. for 3.5 (as noted in the cc: stable line).  But I don't see why
> this isn't needed for earlier kernel versions.  The same broken error
> handling is present.

Hmmm. The error handling is broken since day 1 that is cdfcbd2c4a ("usb:
gadget: dummy_hcd: use the shared_hcd infrastructure") / v3.1-rc1.
Prior v3.5 it is unlikely that something fails here, I never noticed it.
However you are right: wrong is wrong and thefore it should be picked up to
v3.1.

> Ben.

Sebastian
