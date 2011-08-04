Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1HDW4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:56:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55883 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab1HDW4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:56:16 -0400
X-Sasl-enc: mjmm/hyDFtR00Md6+nfStimWNTOpJ+R7tenQusTuj0eC 1312498575
Date: Thu, 4 Aug 2011 15:56:03 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
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
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110804225603.GA2557@kroah.com>
References: <20110610002103.GA7169@xanatos>
 <4E3B1B7B.2040501@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3B1B7B.2040501@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 07:21:47PM -0300, Mauro Carvalho Chehab wrote:
> I know that this problem were somewhat solved for 3G modems, with the usage
> of the userspace problem usb_modeswitch, and with some quirks for the USB
> storage driver, but I'm not sure if such tricks will scale forever, as more
> functions are seen on some USB devices.

Well, no matter how it "scales" it needs to be done in userspace, like
usb_modeswitch does.  We made that decision a while ago, and it is
working out very well.  I see no reason why you can't do it in userspace
as well as that is the easiest place to control this type of thing.

I thought we had a long discussion about this topic a while ago and came
to this very conclusion.  Or am I mistaken?

thanks,

greg k-h
