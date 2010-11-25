Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0KYUWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 15:22:09 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37330 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751735Ab0KYUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 15:22:08 -0500
Date: Thu, 25 Nov 2010 15:22:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Anton Vorontsov <cbouatmailru@gmail.com>, <mkl0301@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dbrownell@users.sourceforge.net>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] USB: cns3xxx: Add EHCI and OHCI bus glue for
 cns3xxx SOCs
In-Reply-To: <20101125171541.GA18152@suse.de>
Message-ID: <Pine.LNX.4.44L0.1011251521310.26094-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Greg KH wrote:

> On Thu, Nov 25, 2010 at 07:21:58PM +0300, Anton Vorontsov wrote:
> > On Thu, Nov 25, 2010 at 11:58:00PM +0800, mkl0301@gmail.com wrote:
> > > From: Mac Lin <mkl0301@gmail.com>
> > > 
> > > The CNS3XXX SOC has include USB EHCI and OHCI compatible controllers. This
> > > patch adds the necessary glue logic to allow ehci-hcd and ohci-hcd drivers to
> > > work on CNS3XXX
> > > 
> > > The EHCI and OHCI controllers share a common clock control and reset bit,
> > > therefore additional check for the timming of enabling and disabling is
> > > required. The USB bit of PLL Power Down Control is also shared by OTG, 24MHz
> > > UART clock, Crypto clock, PCIe reference clock, and Clock Scale Generator.
> > > Therefore we only ensure it is enabled, while not disabling it.
> > > 
> > > Signed-off-by: Mac Lin <mkl0301@gmail.com>
> > 
> > Thanks for the patch!
> > 
> > Cc'ing Greg.
> > 
> > Greg, the patch doesn't touch any sensitive parts of EHCI and OHCI
> > drivers, can I take it via ARM subtree? This is to not introduce
> > cross-tree dependencies (the patch depends on some arch-specific
> > changes).
> 
> Please get Alan Stern to ack it as well, as he knows the proper
> callbacks that you need to ensure are present.

As far as the callbacks are concerned, this looks fine.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

