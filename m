Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1JNAMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 20:12:31 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:39614 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1JNAM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 20:12:29 -0400
Date: Thu, 13 Oct 2011 18:12:28 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 5/5 v14] omap: usb: host: Replace usbhs core driver APIs
 by Runtime pm APIs
In-Reply-To: <20111013175921.GN28290@legolas.emea.dhcp.ti.com>
Message-ID: <alpine.DEB.2.00.1110131812010.24155@utopia.booyaka.com>
References: <1318319531-20476-1-git-send-email-keshava_mgowda@ti.com> <20111013175921.GN28290@legolas.emea.dhcp.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, 13 Oct 2011, Felipe Balbi wrote:

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
> Acked-by: Felipe Balbi <balbi@ti.com>

Thanks, added your ack to the MFD patch and patch 5.

- Paul
