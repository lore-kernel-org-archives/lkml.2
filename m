Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1CAKWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:22:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:40390 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab1CAKWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:22:03 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: btusb autosuspend (was Re: Linux 2.6.38-rc6)
Date: Tue, 1 Mar 2011 11:22:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com> <20110224004333.GA22698@srcf.ucam.org>
In-Reply-To: <20110224004333.GA22698@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011122.13759.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 24. Februar 2011, 01:43:33 schrieb Matthew Garrett:
> On Wed, Feb 23, 2011 at 04:25:23PM -0800, Linus Torvalds wrote:

> > It apparently had problems before too, and caused autosuspend to be
> > disabled entirely, judging at least by
> > 
> >   https://bugzilla.redhat.com/show_bug.cgi?id=528744
> > 
> > but there's obviously the comment about "those should be fixed now".
> > Apparently there are more issues.
> 
> Right, we were autosuspending even when there were active connections. 
> Marcel told me that ought to be fixed and my testing seemed to agree...

It kind of negates any advantage of autosuspend while the device is actually
used. My tests showed that autosuspend on btusb either works well with
active connections or not at all.

> > I have no idea whether this is a USB-level issue, or a driver-level
> > one. There are no comments about exactly what fixed the input device
> > issues. So I'm adding both BT and USB people to the discussion.
> 
> I'll try to get time to look at this this week. Marcel, any ideas?

Matthew, you can set the RESET_RESUME quirk for your test
device. If it works after that, it cansupport only a limited form
of autosuspend.

	HTH
		Oliver
