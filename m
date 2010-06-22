Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab0FVNLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:11:16 -0400
Received: from kroah.org ([198.145.64.141]:55788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab0FVNLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:11:15 -0400
Date: Tue, 22 Jun 2010 06:11:02 -0700
From: Greg KH <greg@kroah.com>
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: 2.6.35-rc3 E-MU 0404 USB problem
Message-ID: <20100622131102.GA18432@kroah.com>
References: <4C20B364.9060405@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C20B364.9060405@blueyonder.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 01:58:12PM +0100, Sid Boyce wrote:
> I have an application using the on-board sound card mic which should
> send it's data to the USB card for relay to a Sofweare Defined Radio
> as 2 quadrature signals digital (I/Q) for transmission.
> On the receiving side it can take data from the Radio at up to 192K
> sample rate --> program --> Speaker on the on-board sound card -
> that works fine.
> Transmit fails, dmesg output with 48K sample rate set is:-
> [509686.177169] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks
> sample rate attribute bit, cannot set.
> [509686.187920] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks
> sample rate attribute bit, cannot set.

Looks like your device does not support this :(

Have you asked on the alsa mailing list?

thanks,

greg k-h
