Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2IMRKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:10:54 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:44313 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab2IMRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:10:52 -0400
Date: Thu, 13 Sep 2012 17:10:51 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Benoit Cousson <b-cousson@ti.com>
cc: Kishon Vijay Abraham I <kishon@ti.com>, balbi@ti.com, tony@atomide.com,
        linux@arm.linux.org.uk, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm: omap: hwmod: make *phy_48m* as the main_clk of
 ocp2scp
In-Reply-To: <505206E3.7050307@ti.com>
Message-ID: <alpine.DEB.2.00.1209131710190.23318@utopia.booyaka.com>
References: <1347008955-21310-1-git-send-email-kishon@ti.com> <alpine.DEB.2.00.1209112218440.9444@utopia.booyaka.com> <505206E3.7050307@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012, Benoit Cousson wrote:

> In this case, the ocp2scp IP is just the *bus controller* to access the
> real USB_UTMI_PHY IP.
> 
> The TRM diagram does not show that level of detail unfortunately. You
> can check the PRCM spec (Figure 78 : CD_L3_INIT_USB clock scheme) to see
> the two modules.
> 
> So considering phy_48m as the main clock is still correct for the
> ocp2scp IP.
> 
> The INIT_960M_FCLK will be a fck associated with the child of the
> ocp2scp nodes which is the usb_phy.
> 
> Upgrading the opt_clk to fck does make sense as soon as we don't have
> any other functional clock and as soon as this clock is *mandatory*. The
> optional aspect in that case is just a wrong PRCM naming for a clock
> that is mandatory. It is similar to the DSS case that does have only
> optional clocks that are mandatory.
> 
> I do agree that we must stick to the HW definition as far as we can. But
> the optional attribute is something that is wrong/inaccurate for a
> couple of IPs. HW folks agreed on that point and will fix that in the
> future.

Okay so is this an Acked-by for this patch? :-)

If so I'll take it.


- Paul
