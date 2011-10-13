Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1JMSMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:12:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59406 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756222Ab1JMSMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:12:00 -0400
Date: Thu, 13 Oct 2011 14:11:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Keshava Munegowda <keshava_mgowda@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, <b-cousson@ti.com>, <paul@pwsan.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>
Subject: Re: [PATCH 5/5 v14] omap: usb: host: Replace usbhs core driver APIs
 by Runtime pm APIs
In-Reply-To: <20111013175921.GN28290@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1110131408440.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Felipe Balbi wrote:

> Hi,
> 
> On Tue, Oct 11, 2011 at 01:22:11PM +0530, Keshava Munegowda wrote:
> > From: Keshava Munegowda <Keshava_mgowda@ti.com>
> > 
> > The ehci and ohci drivers does not use the APIs of the usbhs
> > core driver; the runtime pm APIs are used for clock
> > enable/disable. Since usbhs is parent platform device of the
> > ehci and ohci devices, the runtime apis indirectly uses the
> > usb hs core device as input parameter to for clock functions.
> > 
> > Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> > Reviewed-by: Kevin Hilman <khilman@ti.com>
> > Reviewed-by: Partha Basak <parthab@india.ti.com>
> 
> I'm not sure who should queue this one. Alan, maybe ?

All my stuff goes by way of Greg in any case.

> FWIW:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> as an extra comment, this patch has a very deep dependency on the hwmod
> conversion patches which come before this. If those aren't applied on
> the same merge window, we will have a non-working *HCI driver on OMAP.

To keep things simple, this patch should go through the same submission 
path as the others in the series.  I view it more as an OMAP thing than 
an EHCI thing anyway.  For the record:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

