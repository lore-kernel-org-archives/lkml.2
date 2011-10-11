Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1JKSwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:52:10 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:51498 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab1JKSwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:52:07 -0400
Date: Tue, 11 Oct 2011 12:52:05 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, khilman@ti.com, b-cousson@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, johnstul@us.ibm.com, vishwanath.bs@ti.com,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <20111011140839.GF12293@legolas.emea.dhcp.ti.com>
Message-ID: <alpine.DEB.2.00.1110111136280.1664@utopia.booyaka.com>
References: <20111011081352.GC10155@legolas.emea.dhcp.ti.com> <Pine.LNX.4.44L0.1110111000460.2177-100000@iolanthe.rowland.org> <20111011140839.GF12293@legolas.emea.dhcp.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe

On Tue, 11 Oct 2011, Felipe Balbi wrote:

> maybe, but let's go with EXPORT_SYMBOL_GPL(). My only concern is that
> this IP comes from synopsys, and I'm not really keen on adding
> OMAP-specific, integration-related knowledge on a driver which was
> supposed to be reusable ;-)
>
> But at least for the time being, I guess that's what we need to do ;-)

Which IP is coming from Synopsys - the TLL ?  The EXPORT_SYMBOL approach 
shouldn't add anything OMAP-specific to the TLL driver.  So the exported 
symbols should still be usable by drivers on other SoCs.  But perhaps I am 
misunderstanding your point?

- Paul
