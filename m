Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1KDN7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:59:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab1KDN7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:59:43 -0400
Date: Fri, 4 Nov 2011 06:51:16 -0700
From: Greg KH <gregkh@suse.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 00/19] First round in OTG rework
Message-ID: <20111104135116.GA15231@suse.de>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <20111104132611.GA9965@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104132611.GA9965@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 03:26:11PM +0200, Heikki Krogerus wrote:
> Hi Greg and Felipe,
> 
> On Fri, Oct 28, 2011 at 03:35:06PM +0300, Heikki Krogerus wrote:
> > Changes since v5:
> > - Cleanup isp1704_charger.c
> > 
> > Quick summary:
> > This introduces struct usb_phy and struct usb_otg that
> > replace struct otg_transceiver. The transceiver and phy
> > members from struct otg_transceiver are left in struct
> > usb_phy and otg specific members are moved to struct
> > usb_otg.
> > 
> > So the idea is simply to separate USB PHY handling from OTG.
> >
> > Heikki Krogerus (19):
> >   usb: otg: Rename otg_transceiver to usb_phy
> >   usb: otg: Rename usb_otg and usb_xceiv to usb_phy
> >   usb: otg: Separate otg members from usb_phy
> >   usb: otg: ab8500: Start using struct usb_otg
> >   usb: otg: fsl: Start using struct usb_otg
> >   usb: otg: gpio_vbus: Start using struct usb_otg
> >   usb: otg: isp1301_omap: Start using struct usb_otg
> >   usb: otg: msm: Start using struct usb_otg
> >   usb: otg: langwell: Start using struct usb_otg
> >   usb: otg: nop: Start using struct usb_otg
> >   usb: otg: twl4030: Start using struct usb_otg
> >   usb: otg: twl6030: Start using struct usb_otg
> >   usb: otg: ulpi: Start using struct usb_otg
> >   arm: imx: Start using struct usb_otg
> >   usb: musb: Start using struct usb_otg
> >   power_supply: Convert all users to new usb_phy
> >   usb: Convert all users to new usb_phy
> >   usb: otg: Remove OTG specific members from usb_phy
> >   usb: otg: Convert all users to pass struct usb_otg for OTG functions
> 
> It seems that there are not more comments to these. When can you take
> them?

Please realize that this is the "busy" period for the subsystem
maintainers during the merge window.  We will be glad to review these
_after_ the window closes, and queue them up for next time.

Well, in this case, Felipe will do the reviewing and queuing up, not me,
he's a busy person, give him some time please :)

thanks,

greg k-h
