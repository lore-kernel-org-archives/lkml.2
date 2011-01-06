Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1AFJnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:43:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59554 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1AFJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:42:59 -0500
Date: Thu, 6 Jan 2011 09:42:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julien Boibessot <julien.boibessot@free.fr>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, liu.y.victor@gmail.com,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, B02280@freescale.com
Subject: Re: [PATCH v2] i.MX51 Framebuffer support
Message-ID: <20110106094237.GB31708@n2100.arm.linux.org.uk>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de> <4D246C54.9060503@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D246C54.9060503@free.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 02:04:20PM +0100, Julien Boibessot wrote:
> Hello,
> 
> Sascha Hauer a écrit :
> > The following series adds i.MX51 framebuffer support based on the IPUv3. It
> > is not perfect but I decided it is good enough to open it for a wider audience
> > and collect first reviews. I tested this on a babbage board using both outputs
> > (VGA/DVI) with different resolutions up to 1680x1050 and different colour depths.
> > I also tested it on one custom board using a fixed display setting.
> >   
> This driver is also working fine for me on a custom i.MX51 board with a
> 800x480 18 bits TFT LCD (16bpp mode).
> 
> The only strange thing I noticed was a kind of uggly sprite/artefact
> (32x32, I would say) appearing at the same time as the Linux console. I
> think it may be related to a hardware cursor badly (?) initialised, but
> I didn't find a fix yet.
> It disappears when I launch a graphical application (Qt or SDL).

In the top left corner?  That'll be the linux penguin logo, and if it's
not coming out correctly, your framebuffer driver is badly broken.
Maybe your RGB bitfield information or visual is wrong?
