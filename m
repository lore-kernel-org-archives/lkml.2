Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0KZRSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:18:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:36291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0KZRSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:18:13 -0500
Date: Fri, 26 Nov 2010 09:03:48 -0800
From: Greg KH <gregkh@suse.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, mkl0301@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/1] USB: cns3xxx: Add EHCI and OHCI bus glue for
	cns3xxx SOCs
Message-ID: <20101126170348.GA3331@suse.de>
References: <20101125171541.GA18152@suse.de> <Pine.LNX.4.44L0.1011251521310.26094-100000@netrider.rowland.org> <20101126151131.GA26602@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126151131.GA26602@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 06:11:31PM +0300, Anton Vorontsov wrote:
> On Thu, Nov 25, 2010 at 03:22:06PM -0500, Alan Stern wrote:
> [...]
> > > > > From: Mac Lin <mkl0301@gmail.com>
> > > > > 
> > > > > The CNS3XXX SOC has include USB EHCI and OHCI compatible controllers. This
> > > > > patch adds the necessary glue logic to allow ehci-hcd and ohci-hcd drivers to
> > > > > work on CNS3XXX
> > > > > 
> > > > > The EHCI and OHCI controllers share a common clock control and reset bit,
> > > > > therefore additional check for the timming of enabling and disabling is
> > > > > required. The USB bit of PLL Power Down Control is also shared by OTG, 24MHz
> > > > > UART clock, Crypto clock, PCIe reference clock, and Clock Scale Generator.
> > > > > Therefore we only ensure it is enabled, while not disabling it.
> > > > > 
> > > > > Signed-off-by: Mac Lin <mkl0301@gmail.com>
> > > > 
> > > > Thanks for the patch!
> > > > 
> > > > Cc'ing Greg.
> > > > 
> > > > Greg, the patch doesn't touch any sensitive parts of EHCI and OHCI
> > > > drivers, can I take it via ARM subtree? This is to not introduce
> > > > cross-tree dependencies (the patch depends on some arch-specific
> > > > changes).
> > > 
> > > Please get Alan Stern to ack it as well, as he knows the proper
> > > callbacks that you need to ensure are present.
> > 
> > As far as the callbacks are concerned, this looks fine.
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Thanks Alan!
> 
> Greg, should I treat your 'to ack it as well' as 'Acked-by'? :-)

Yes please:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

