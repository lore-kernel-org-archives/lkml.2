Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1HHR6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:58:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:8082 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1HHR6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,338,1309762800"; 
   d="scan'208";a="35713363"
Date: Mon, 8 Aug 2011 10:58:37 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110808175837.GA6398@xanatos>
References: <20110610002103.GA7169@xanatos>
 <4E3B1B7B.2040501@infradead.org>
 <20110804225603.GA2557@kroah.com>
 <4E3B9FB4.30709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3B9FB4.30709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 09:45:56AM +0200, Hans de Goede wrote:
> Hi,
> 
> On 08/05/2011 12:56 AM, Greg KH wrote:
> >On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
> I think it is important to separate oranges from apples here, there are
> at least 3 different problem classes which all seem to have gotten thrown
> onto a pile here:
> 
> 1) The reason Mauro suggested having some discussion on this at the
> USB summit is because of a discussion about dual mode cameras on the
> linux media list.
...
> 3) Re-direction of usb devices to virtual machines. This works by using
> the userspace usbfs interface from qemu / vmware / virtualbox / whatever.
> The basics of this work fine, but it lacks proper locking / safeguards
> for when a vm takes over a usb device from the in kernel driver.

Hi Hans and Mauro,

We have do room in the schedule for the USB mini-summit for this
discussion, since the schedule is still pretty flexible.  The
preliminary schedule is up here:

http://userweb.kernel.org/~sarah/linuxcon-usb-minisummit.html

I think it's best to discuss the VM redirection in the afternoon when
some of the KVM folks join us after Hans' talk on USB redirection over
the network.

It sounds like we need a separate topic for the dual mode cameras and TV
tuners.  Mauro, do you want to lead that discussion in the early morning
(in a 9:30 to 10:30 slot) or in the late afternoon (in a 15:30 to 16:30
slot)?  I want to be sure we have all the video/media developers who are
interested in this topic present, and I don't know if they will be going
to the KVM forum.

Link PM was originally slated for the 10am slot, but since we're missing
several people for that discussion (Alan Stern, Andiry Xu, and any of
the Intel folks who did the Moorestown USB 2.0 LPM), I think it will be
more useful to have that discussion on-list or at another conference.

Sarah Sharp
