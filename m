Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1FJDSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:18:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50586 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862Ab1FJDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:18:34 -0400
X-Sasl-enc: 2/3j7uSZ/+ZpX5hvA406h1voxW8JLNhqn4LDiUqsumPS 1307675912
Date: Thu, 9 Jun 2011 20:18:05 -0700
From: Greg KH <greg@kroah.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110610031805.GA15774@kroah.com>
References: <20110610002103.GA7169@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610002103.GA7169@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 05:21:03PM -0700, Sarah Sharp wrote:
> Topic 1
> -------
> 
> The KVM folks suggested that it would be good to get USB and
> virtualization developers together to talk about how to virtualize the
> xHCI host controller.  The xHCI spec architect worked closely with
> VMWare to get some extra goodies in the spec to help virtualization, and
> I'd like to see the other virtualization developers take advantage of
> that.  I'd also like us to hash out any issues they have been finding in
> the USB core or xHCI driver during the virtualization effort.

Do people really want to virtualize the whole xHCI controller, or just
specific ports or devices to the guest operating system?

If just specific ports, would something like usbip be better for virtual
machines, with the USB traffic going over the network connection between
the guest/host?

> Hope to see you there!

Thanks for putting this together.

Do we need to sign up somewhere to give the organizers a sense of how
many people will be attending?

thanks,

greg k-h
