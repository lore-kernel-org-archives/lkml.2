Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2EXEpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:45:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49900 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2EXEpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:45:42 -0400
Date: Wed, 23 May 2012 21:45:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: prasannatsmkumar <prasannatsmkumar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why USB Link Power Management only for devices connected to root
 hub
Message-ID: <20120524044537.GB14325@kroah.com>
References: <CANc+2y50jirP=_V0qBkDuVwkhcmJWo3tQ-rwnxOtw3GQ5gP3tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANc+2y50jirP=_V0qBkDuVwkhcmJWo3tQ-rwnxOtw3GQ5gP3tQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:42:28AM +0530, prasannatsmkumar wrote:
> I have started looking into USB stuff. In the EHCI driver code I could
> see the comment that "we only support lpm device connected to root hub
> yet" in drivers/usb/host/ehci-pci.c line 466 (3.4 kernel -
> http://lxr.free-electrons.com/source/drivers/usb/host/ehci-pci.c#L466).
> Is there any reason to not support lpm in devices connected to hub
> (other than root hub)? Also inside ehci_lpm_check function in
> drivers/usb/host/ehci-lpm.c (3.4 kernel -
> http://lxr.free-electrons.com/source/drivers/usb/host/ehci-lpm.c) the
> USB device is asked to go to LPM mode and there is a wait for 10ms. I
> guess the LPM transition (L0 to L1 state transition) should take place
> within some micro seconds then why should we wait for 10ms for ACK?

Please as USB-specific questions like this on the linux-usb mailing list
if you wish to get answers.

greg k-h
