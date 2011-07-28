Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1G1P1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:27:38 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32774 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694Ab1G1P1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:27:34 -0400
X-Sasl-enc: pDxVaNbyl9LAzJo+/Raxhwg3CFH+Xibs8s7NfcJGVMMJ 1311866853
Date: Thu, 28 Jul 2011 08:18:06 -0700
From: Greg KH <greg@kroah.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2/2] ASIX: Use only 11 bits of header for data size
Message-ID: <20110728151806.GB22202@kroah.com>
References: <1311734687-23551-1-git-send-email-marek.vasut@gmail.com>
 <1311734687-23551-2-git-send-email-marek.vasut@gmail.com>
 <20110727.224029.619127041796367339.davem@davemloft.net>
 <201107280806.18813.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107280806.18813.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 08:06:18AM +0200, Marek Vasut wrote:
> On Thursday, July 28, 2011 07:40:29 AM David Miller wrote:
> > From: Marek Vasut <marek.vasut@gmail.com>
> > Date: Wed, 27 Jul 2011 04:44:47 +0200
> > 
> > > The AX88772B uses only 11 bits of the header for the actual size. The
> > > other bits
> > > 
> > > are used for something else. This causes dmesg full of messages:
> > > 	asix_rx_fixup() Bad Header Length
> > > 
> > > This patch trims the check to only 11 bits. I believe on older chips, the
> > > remaining 5 top bits are unused.
> > > 
> > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > 
> > Applied.
> 
> Hi, did you test it ?
> 
> I left NOTEs outside the commit message:
> 
> NOTE: If possible, can someone test/verify this patch with other ASIX chips ?
> NOTE2: If Ack-ed, Greg, can you get this into -stable?

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
