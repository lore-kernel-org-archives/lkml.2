Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1HJU3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:29:51 -0400
Received: from banach.math.auburn.edu ([131.204.45.3]:58215 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1HJU3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:29:49 -0400
Date: Wed, 10 Aug 2011 15:34:06 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Greg KH <greg@kroah.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <20110810194325.GA19916@kroah.com>
Message-ID: <alpine.LNX.2.00.1108101532560.25232@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1108101300500.25084@banach.math.auburn.edu> <20110810194325.GA19916@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Aug 2011, Greg KH wrote:

> On Wed, Aug 10, 2011 at 01:33:25PM -0500, Theodore Kilgore wrote:
> > -- moving the kernel webcam drivers out of the kernel and doing with these 
> > cameras _everything_ including webcam function through libusb. I myself do 
> > not have the imagination to be able to figure out how this could be done 
> > without a rather humongous amount of work (for example, which streaming 
> > apps that are currently available would be able to live with this?) but 
> > unless I misunderstand what he was saying, Greg K-H seems to think that 
> > this would be the best thing to do.
> 
> No, I never said that.  Or if I accidentally did, I do not think that is
> the best thing to do at all, sorry for any confusion.

OK.
 
> > Which one of these possibile approaches gets adopted is a policy issue 
> > which I would consider is ultimately way above my pay grade.
> 
> As no one is being paid here, there are no "pay grades", so don't worry
> about that :)

I meant this, of course, in a metaphorical sense.

Cheers,
Theodore Kilgore
