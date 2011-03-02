Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1CBVJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:09:40 -0500
Received: from kroah.org ([198.145.64.141]:54642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab1CBVJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:09:39 -0500
Date: Wed, 2 Mar 2011 16:01:27 -0500
From: Greg KH <greg@kroah.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [RFC PATCH] staging: xgifb: remove private ioctls
Message-ID: <20110302210127.GA20522@kroah.com>
References: <1299016212-1060-1-git-send-email-aaro.koskinen@iki.fi>
 <20110302153132.GA7325@kroah.com>
 <alpine.DEB.1.10.1103021931550.3526@loser>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1103021931550.3526@loser>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 08:19:11PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Wed, 2 Mar 2011, Greg KH wrote:
> >On Tue, Mar 01, 2011 at 11:50:12PM +0200, Aaro Koskinen wrote:
> >>Drop the badly defined and broken private ioctl interface. Since the
> >>driver is in staging, and some of the ioctls are clearly unsafe or not
> >>even working, it's unlikely that there are any users.
> >>
> >>Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> >
> >Is this just a RFC, or do you want me to apply this patch?
> 
> I wasn't sure if we should try to retain all the interfaces the driver
> provides. But if there are no objections, please apply, it will help a
> lot with further cleanups.

Ok, care to resend it without the RFC then?

thanks,

greg k-h
