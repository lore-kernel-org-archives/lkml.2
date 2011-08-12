Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1HLPg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:36:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34987 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752855Ab1HLPg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:36:56 -0400
Date: Fri, 12 Aug 2011 11:36:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Hans de Goede <hdegoede@redhat.com>
cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <libusb-devel@lists.sourceforge.net>,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        <hector@marcansoft.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <4E44D5B5.7040305@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1108121135390.11936-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011, Hans de Goede wrote:

> > I'm not claiming that this is a better solution than putting everything
> > in the kernel.  Just that it is a workable alternative which would
> > involve a lot less coding.
> 
> This is definitely an interesting proposal, something to think about ...
> 
> I have 2 concerns wrt this approach:
> 
> 1) It feels less clean then just having a single driver; and

Agreed.

> 2) I agree it will be less coding, but I doubt it will really be that much
> less work. It will likely need less new code (but a lot can be more or
> less copy pasted), but it will need changes across a wider array of
> subsystems / userspace components, requiring a lot of coordinating,
> getting patches merged in different projects, etc. So in the end I
> think it too will be quite a bit of work.
> 
> I guess that what I'm trying to say here is, that if we are going to
> spend a significant amount of time on this, we might just as well
> go for the best solution we can come up with even if that is some
> more work.

Okay, go ahead.  I have no objection.

Alan Stern

