Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1HIOT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:19:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35603 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752196Ab1HIOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:19:23 -0400
Date: Tue, 9 Aug 2011 10:19:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hans de Goede <hdegoede@redhat.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
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
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <4E40E74C.9060902@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Hans de Goede wrote:

> I would really like to see the dual mode camera and TV tuner discussion
> separated. They are 2 different issues AFAIK.
> 
> 1) Dual mode cameras:
> 
> In the case of the dual mode camera we have 1 single device (both at
> the hardware level and at the logical block level), which can do 2 things,
> but not at the same time. It can stream live video data from a sensor,
> or it can retrieve earlier taken pictures from some picture memory.
> 
> Unfortunately even though these 2 functions live in a single logical block,
> historically we've developed 2 drivers for them. This leads to fighting
> over device ownership (surprise surprise), and to me the solution is
> very clear, 1 logical block == 1 driver.

According to Theodore, we have developed 5 drivers for them because the
stillcam modes in different devices use four different vendor-specific
drivers.  Does it really make sense to combine 5 drivers into one?  I 
think some sort of sharing protocol would work out better.

Alan Stern

