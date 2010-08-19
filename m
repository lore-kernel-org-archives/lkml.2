Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0HSNJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:09:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:39031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0HSNJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:09:49 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Raju Rameshwar Uprade <rajsingh@gmrt.ncra.tifr.res.in>
Subject: Re: Regarding USB-Serial Device driver
Date: Thu, 19 Aug 2010 15:09:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-usb" <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.63.1008191155040.3096@eng1.gmrt.ncra.tifr.res.in>
In-Reply-To: <Pine.LNX.4.63.1008191155040.3096@eng1.gmrt.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191509.47636.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 19. August 2010, 08:28:57 schrieb Raju Rameshwar Uprade:
> Dear All,
>          I am trying to write a Pl2303_mcm.c usb-serial device driver which 
> will be able
> to talk to several devices using RS-485 interface card.I have modified the 
> standard
> pl2303.c by which I am able to enable/disable the RTS line.
> I am sending 10 bytes of data to the device, data is going out but instead 
> of 10 bytes,
> device driver is sending a large amount of data as seen on Lecroy 
> waverunner
> oscilloscope. Here I am sending the modified file.

Could you please send this as a unified diff?
And take the USB list into cc? Do you see this superfluous
data also with usbmon?

	Regards
		Oliver
