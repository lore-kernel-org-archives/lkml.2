Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0C2Q6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:58:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37490 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754059Ab0C2Q6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:58:08 -0400
Date: Mon, 29 Mar 2010 12:58:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003291224170.27175@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1003291253410.3358-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, Justin Piszcz wrote:

> bus pci, device 0000:00:0b.0
> OHCI Host Controller
> ohci_hcd
> OHCI 1.0, NO legacy support registers
> control 0x68f RWE RWC HCFS=operational IE PLE CBSR=3
> cmdstatus 0x00000 SOC=0
> intrstatus 0x00000020 FNO
> intrenable 0x8000004e MIE RHSC RD SF WDH
> ed_controlhead 7bef1b90
> hcca frame 0x4657
> fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
> fmremaining 0x80002b76 FRT FR=0x2b76
> periodicstart 0x2a2f
> lsthresh 0x0628
> hub poll timer off
> roothub.a 01000208 POTPGT=1 NPS NDP=8(8)
> roothub.b 00000000 PPCM=0000 DR=0000
> roothub.status 00008000 DRWE
> roothub.portstatus [0] 0x00000100 PPS
> roothub.portstatus [1] 0x00000100 PPS
> roothub.portstatus [2] 0x00000100 PPS
> roothub.portstatus [3] 0x00000100 PPS
> roothub.portstatus [4] 0x00000303 LSDA PPS PES CCS
> roothub.portstatus [5] 0x00000303 LSDA PPS PES CCS
> roothub.portstatus [6] 0x00000100 PPS
> roothub.portstatus [7] 0x00000100 PPS

I don't notice anything suspicious there.

> > At the same time, just to be increase my level of certainty, you should
> > apply the following debugging patch for ohci-hcd.  Let's see both the
> > usbmon trace and the dmesg log for the same event.  The trace and the
> > debugging patch will generate plenty of output during normal operation,
> > but don't worry about that.  Only the part starting from shortly before
> > the mouse quits really matters.
> Yes, I've done this before for a bug in the Intel USB controller (P55) on
> another motherboard.. Should be doable, always funny though how it does not
> happen when you are trying to make it happen.
> 
> For your patch, what does this patch against? It does not apply cleanly
> for 2.6.33.

Yes it does.  Maybe there's something wrong with the way your email 
client extracted the patch from the message.

> It also fails against 2.6.34-rc2, can you diff -u and show the patch so
> I can patch manually or include a patch against 2.6.33 or 2.6.34-rc2? 

That _was_ a "diff -u"-style patch.

Alan Stern

