Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1G1QR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:17:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63961 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab1G1QRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:17:54 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/2] ASIX: Use only 11 bits of header for data size
Date: Thu, 28 Jul 2011 18:17:49 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.3; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
References: <1311734687-23551-1-git-send-email-marek.vasut@gmail.com> <201107280806.18813.marek.vasut@gmail.com> <20110728151806.GB22202@kroah.com>
In-Reply-To: <20110728151806.GB22202@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107281817.49843.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 28, 2011 05:18:06 PM Greg KH wrote:
> On Thu, Jul 28, 2011 at 08:06:18AM +0200, Marek Vasut wrote:
> > On Thursday, July 28, 2011 07:40:29 AM David Miller wrote:
> > > From: Marek Vasut <marek.vasut@gmail.com>
> > > Date: Wed, 27 Jul 2011 04:44:47 +0200
> > > 
> > > > The AX88772B uses only 11 bits of the header for the actual size. The
> > > > other bits
> > > > 
> > > > are used for something else. This causes dmesg full of messages:
> > > > 	asix_rx_fixup() Bad Header Length
> > > > 
> > > > This patch trims the check to only 11 bits. I believe on older chips,
> > > > the remaining 5 top bits are unused.
> > > > 
> > > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > > 
> > > Applied.
> > 
> > Hi, did you test it ?
> > 
> > I left NOTEs outside the commit message:
> > 
> > NOTE: If possible, can someone test/verify this patch with other ASIX
> > chips ? NOTE2: If Ack-ed, Greg, can you get this into -stable?
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.

Yea I know ... I'm just so very tired (read dead). Sorry
> 
> </formletter>
