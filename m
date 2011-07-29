Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1G2U1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:27:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34696 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1G2U1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:27:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] better oopsing when frozen
Date: Fri, 29 Jul 2011 22:29:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <201107251043.19932.oneukum@suse.de> <20110729195430.GB1720@ucw.cz> <201107292227.36424.oliver@neukum.org>
In-Reply-To: <201107292227.36424.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107292229.02402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 29, 2011, Oliver Neukum wrote:
> Am Freitag, 29. Juli 2011, 21:54:30 schrieb Pavel Machek:
> > On Mon 2011-07-25 10:43:19, Oliver Neukum wrote:
> > > Hi Rafael,
> > > 
> > > I had a problem with the kernel stopping the machine forever because I got an
> > > oops while tasks were frozen. It seems to me that we should thaw when this
> > > happens. How about this approach?
> > 
> > Danger, Will Robinson. You must not write to the filesystems after
> > hibernation started. By thawing, you may do just that.
> > 
> > It should be safe to thaw as long as final suspend signature is not
> > on disk and will not be written there.
> 
> Yes. But this applies only if I use kernel-space hibernation, doesn't it?
> So I need a second flag for the signature being written. Any other problem?

Yes, please see my reply to Pavel.

Thanks,
Rafael
