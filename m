Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab0FVNek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:34:40 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52753 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0FVNej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:34:39 -0400
Date: Tue, 22 Jun 2010 15:34:34 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <greg@kroah.com>
Cc: Sid Boyce <sboyce@blueyonder.co.uk>,
       LKML Mailing List <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: 2.6.35-rc3 E-MU 0404 USB problem
Message-ID: <20100622133434.GZ2698@buzzloop.caiaq.de>
References: <4C20B364.9060405@blueyonder.co.uk>
 <20100622131102.GA18432@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622131102.GA18432@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 06:11:02AM -0700, Greg KH wrote:
> On Tue, Jun 22, 2010 at 01:58:12PM +0100, Sid Boyce wrote:
> > I have an application using the on-board sound card mic which should
> > send it's data to the USB card for relay to a Sofweare Defined Radio
> > as 2 quadrature signals digital (I/Q) for transmission.
> > On the receiving side it can take data from the Radio at up to 192K
> > sample rate --> program --> Speaker on the on-board sound card -
> > that works fine.
> > Transmit fails, dmesg output with 48K sample rate set is:-
> > [509686.177169] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks
> > sample rate attribute bit, cannot set.
> > [509686.187920] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks
> > sample rate attribute bit, cannot set.
> 
> Looks like your device does not support this :(
> 
> Have you asked on the alsa mailing list?

Yes, please post this on the ALSA list, and also provide the full output
of "lsusb -v" with the device connected.

Thanks,
Daniel
