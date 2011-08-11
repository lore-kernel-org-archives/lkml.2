Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1HKI6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:58:09 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:56884 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1HKI6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:58:06 -0400
Date: Thu, 11 Aug 2011 10:57:50 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110811105750.179e468a@tele>
In-Reply-To: <4E42E68D.6040501@infradead.org>
References: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org>
	<alpine.LNX.2.00.1108101300500.25084@banach.math.auburn.edu>
	<4E42E68D.6040501@infradead.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 17:14:05 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> > -- moving the kernel webcam drivers out of the kernel and doing with these 
> > cameras _everything_ including webcam function through libusb. I myself do 
> > not have the imagination to be able to figure out how this could be done 
> > without a rather humongous amount of work (for example, which streaming 
> > apps that are currently available would be able to live with this?) but 
> > unless I misunderstand what he was saying, Greg K-H seems to think that 
> > this would be the best thing to do.  
> 
> I also don't think that this a good alternative. As Hans V. pointed, one of
> our long term targets is to create per-sensor I2C drivers that are independent
> from the bridges. Also, moving it to userspace would require lots of work
> with the duplication of V4L and gspca core into userspace for the devices
> that would be moved, and may have some performance impacts.

If only gspca subdrivers are concerned, moving them to usespace should
be easy: only the gspca main has to be rewritten, and its best place is
in the v4l library.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
