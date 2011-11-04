Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1KDN0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:26:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:40427 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1KDN0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:26:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="71044908"
Date: Fri, 4 Nov 2011 15:26:11 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 00/19] First round in OTG rework
Message-ID: <20111104132611.GA9965@xps8300>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Felipe,

On Fri, Oct 28, 2011 at 03:35:06PM +0300, Heikki Krogerus wrote:
> Changes since v5:
> - Cleanup isp1704_charger.c
> 
> Quick summary:
> This introduces struct usb_phy and struct usb_otg that
> replace struct otg_transceiver. The transceiver and phy
> members from struct otg_transceiver are left in struct
> usb_phy and otg specific members are moved to struct
> usb_otg.
> 
> So the idea is simply to separate USB PHY handling from OTG.
>
> Heikki Krogerus (19):
>   usb: otg: Rename otg_transceiver to usb_phy
>   usb: otg: Rename usb_otg and usb_xceiv to usb_phy
>   usb: otg: Separate otg members from usb_phy
>   usb: otg: ab8500: Start using struct usb_otg
>   usb: otg: fsl: Start using struct usb_otg
>   usb: otg: gpio_vbus: Start using struct usb_otg
>   usb: otg: isp1301_omap: Start using struct usb_otg
>   usb: otg: msm: Start using struct usb_otg
>   usb: otg: langwell: Start using struct usb_otg
>   usb: otg: nop: Start using struct usb_otg
>   usb: otg: twl4030: Start using struct usb_otg
>   usb: otg: twl6030: Start using struct usb_otg
>   usb: otg: ulpi: Start using struct usb_otg
>   arm: imx: Start using struct usb_otg
>   usb: musb: Start using struct usb_otg
>   power_supply: Convert all users to new usb_phy
>   usb: Convert all users to new usb_phy
>   usb: otg: Remove OTG specific members from usb_phy
>   usb: otg: Convert all users to pass struct usb_otg for OTG functions

It seems that there are not more comments to these. When can you take
them?

-- 
heikki
