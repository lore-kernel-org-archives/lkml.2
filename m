Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1HEDfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:35:31 -0400
Received: from banach.math.auburn.edu ([131.204.45.3]:58976 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab1HEDfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:35:12 -0400
X-Greylist: delayed 2562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 23:35:12 EDT
Date: Thu, 4 Aug 2011 21:56:27 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Greg KH <greg@kroah.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <20110804225603.GA2557@kroah.com>
Message-ID: <alpine.LNX.2.00.1108042108210.18033@banach.math.auburn.edu>
References: <20110610002103.GA7169@xanatos> <4E3B1B7B.2040501@infradead.org> <20110804225603.GA2557@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Aug 2011, Greg KH wrote:

> On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
> > I know that this problem were somewhat solved for 3G modems, with the usage
> > of the userspace problem usb_modeswitch, and with some quirks for the USB
> > storage driver, but I'm not sure if such tricks will scale forever, as more
> > functions are seen on some USB devices.
> 
> Well, no matter how it "scales" it needs to be done in userspace, like
> usb_modeswitch does.  We made that decision a while ago, and it is
> working out very well.  I see no reason why you can't do it in userspace
> as well as that is the easiest place to control this type of thing.
> 
> I thought we had a long discussion about this topic a while ago and came
> to this very conclusion.  Or am I mistaken?
> 
> thanks,
> 
> greg k-h
> 

Greg,

A little bit more of precision would help me a lot, here. Precisely what 
is one supposed to do in userspace? I would naturally assume that the user 
will control the device by announcing what the user wants to do with the 
device. Such control would therefore have to start in userspace. But this 
is such an obvious truism that you must mean something else. What, then?

To say to do things "like usb_modeswitch" is rather vague. For one thing, 
usb_modeswitch, being something out there in userspace, does _not_ affect 
what is in the kernel. However, what is (or is not) in the kernel might 
make it possible (or, in the alternative, impossible) to facilitate the 
action of some kind of userspace function-switching program similar to 
usb_modeswitch, not so? 

As to the "long discussion about this topic a while ago" that may have 
been a discussion in which I was also involved. For, I do remember a 
discussion about this topic a few months ago. In one respect my memory 
differs from yours, however: It was not my impression that any definite 
conclusions were reached, certainly not a consensus. BTW, I did try to lay 
out what I remembered as three alternatives that came up, along with 
arguments for and against each of them, in my message which kicked off 
this thread today. 

It is of course a real possibility that you have seen the perfect solution 
in your mind to these problems, which have vexed a lot of people for 
years, and others have not. If that is the way it is, then perhaps you 
just wish that we would all shut up, implement what is obvious, and we 
could all be happy. This could certainly be the case. You have written a 
lot more code than I have, and you obviously must have started doing that 
when you were at least 30 years younger, perhaps even 40 years younger, 
than I was when I started. So I would be the first to say that you are 
much better at it than I am. But there are others here, too, who seem 
actively to have been sucked into this discussion, and they are similarly 
younger and more clever than I am, too. 

Giving due consideration to this, it would probably get the job done a lot 
faster if you just take the time to describe what grand vision you 
yourself have in mind for the solution of the problem, with a sufficient 
accounting of the details that people can all see what it is and exactly 
how and why it would work absolutely perfectly, and then we can just get 
busy and do it.

Theodore Kilgore
