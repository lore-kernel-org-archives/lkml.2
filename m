Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2GITt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:49:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60882 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2GITtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:49:55 -0400
Date: Mon, 9 Jul 2012 16:49:47 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Henrik Rydberg <rydberg@bitmath.se>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add MacBookPro10,1 support
Message-ID: <20120709194947.GA17281@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Henrik Rydberg <rydberg@bitmath.se>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1341856347-257-1-git-send-email-rydberg@euromail.se>
 <20120709184824.GA21411@x220>
 <20120709192529.GA712@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709192529.GA712@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

* Henrik Rydberg <rydberg@bitmath.se> [2012-07-09 21:25:29 +0200]:

> On Mon, Jul 09, 2012 at 03:48:24PM -0300, Johan Hedberg wrote:
> > Hi Henrik,
> > 
> > On Mon, Jul 09, 2012, Henrik Rydberg wrote:
> > > Add support for the 2012 15'' MacBook Pro Retina.
> > > 
> > > Patch originally written by clipcarl (forums.opensuse.org).
> > > 
> > > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > > ---
> > > Hi Gustavo,
> > > 
> > > This patch adds support for the new retina. Picked up from the suse
> > > forum. Getting it into 3.5 would be great, if possible.
> > > 
> > > Cheers,
> > > Henrik
> > > 
> > >  drivers/bluetooth/btusb.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > 
> > I believe the requirement is to always include a usb-devices output in
> > the commit message (to let maintainers confirm that no typo has occurred
> > in the patch itself).

If you don't have access to the device I can take it without usb-devices,
otherwise just add it to the patch and then resend.

	Gustavo
