Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2JVOVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:21:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53240 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754727Ab2JVOVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:21:34 -0400
Date: Mon, 22 Oct 2012 10:21:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Stephen Warren <swarren@wwwdotorg.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
In-Reply-To: <20121022075611.GC14033@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1210221020190.1724-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Felipe Balbi wrote:

> Hi,
> 
> On Fri, Oct 19, 2012 at 10:29:35AM -0600, Stephen Warren wrote:
> > On 10/19/2012 09:35 AM, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
> > >> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc. In
> > >> order to support USB PHY drivers on these SoCs, existing PHY
> > >> driver is split into SoC agnostic common USB PHY driver and
> > >> Tegra20-specific USB phy driver. This will facilitate easy
> > >> addition and deletion of phy drivers for Tegra SoCs.
> > >> 
> > >> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > > 
> > > I was reading this "driver" more closely and I have a bunch of
> > > questions about it, but the most important of all of them is: "why
> > > isn't that a real PHY driver ?". It doesn't have a probe()
> > > function, it doesn't use struct usb_phy to represent the PHY, it
> > > has a bunch of tegra-specific APIs and we can't let those
> > > continue.
> > 
> > One question here: If the PHY "driver" API changes, there will need to
> > be a bunch of ehci-tegra.c changes too. Will you take all those
> 
> hmm.. indeed.
> 
> > through the PHY tree? If you expect to do that, then I'd like to
> 
> I can take those if Alan is ok with it :-) Alan ?

I don't mind a bit.  It's kind of difficult for me to review changes to 
the platform-specific parts of the these drivers, anyway.  I have no 
way to test them and I'm not familiar with the interfaces involved.

Alan Stern

