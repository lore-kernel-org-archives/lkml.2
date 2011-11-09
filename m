Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1KIGPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:15:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57902 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1KIGPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:15:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111109060649.GC23337@legolas.emea.dhcp.ti.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
	<CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
	<20111109012237.GA2231@nchen-desktop>
	<20111109060649.GC23337@legolas.emea.dhcp.ti.com>
Date: Wed, 9 Nov 2011 14:15:43 +0800
Message-ID: <CAL411-qpW4dNUMTwh4gP_M+i_UOzc7q84gH+qJWeAYaSCgBCJg@mail.gmail.com>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
From: Peter Chen <hzpeterchen@gmail.com>
To: balbi@ti.com
Cc: Peter Chen <peter.chen@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Includes fixes to IMX code from Sascha Hauer.
> > >
> > > I tend to defer with your opinion of renaming otg_transceiver to
> > > usb_phy. According to me otg_transceiver should program hardware
> > > mechanisms associated to VBUS, ID lines, etc.. and phy is responsible
> > > for transmitting data over differential data lines (with its own
> > > programming of phy_init, phy_shutdown, setting phy clocks etc..). So
> > > in my opinion otg_transceiver and usb_phy should be two different and
> > > separate entities.
> > >
> > I am a little puzzled, are there two separate analog usb parts at OMap
> > 's usb part? What the transceiver do? And what the phy do?
>
> Kinda... there's one which is mostly digital inside the SoC handling
> data lines and also comunicating VBUS/ID levels to the link but the
> actual VBUS/ID comparators are outside of the SoC, inside the PMIC.
>
> It's a bit of a pain, but I understand why they did it that way. It's
> mostly for power management, although the same is likely to be
> achievable by keeping everything in the PMIC.
>
So, in that way, the users must choose specific PMICs which have USB
interface if
they want to use OMAP

> --
> balbi



--
BR,
Peter Chen
