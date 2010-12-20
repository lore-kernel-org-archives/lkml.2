Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab0LTUAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:00:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:50682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab0LTUAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:00:10 -0500
Date: Mon, 20 Dec 2010 11:58:47 -0800
From: Greg KH <gregkh@suse.de>
To: merez@codeaurora.org
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v2] usb: Add streams support to epautoconf.
Message-ID: <20101220195847.GA2479@suse.de>
References: <e81cf70b35cab2396bf79c3fbc9c268b.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e81cf70b35cab2396bf79c3fbc9c268b.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 11:33:44AM -0800, merez@codeaurora.org wrote:
> > On Thu, Dec 16, 2010 at 10:15AM, Greg KH wrote:
> > What do you exactly mean by "proprietary search algorithm"?
> Our implementation for finding an EP with the required number of streams
> may not fit the needs and platform definitions of all controllers.  For
> example, having the minimum number of streams as a parameter will allow
> controllers to compromise on the number of required streams in case there
> is no EP that answers their first request.
> At the beginning of usb_ep_autoconfig we could see many if statements for
> finding the fitting EP for several controllers (for example
> gadget_is_net2280). The new gadget op will prevent having additional if
> statements in the usb_ep_autoconfig in case a different search is needed. 

Ok, but please note the word of "proprietary" usually means something
else when talking about kernel code (i.e. licensing issues.)

I'll be glad to take this type of patch when you also provide a patch
that uses the callback, but not before then.

thanks,

greg k-h
