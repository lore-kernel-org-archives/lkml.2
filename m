Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2BHLZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:25:50 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:59692 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890Ab2BHLZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:25:26 -0500
Message-ID: <1328700319.20197.54.camel@cumari>
Subject: Re: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
From: Luciano Coelho <coelho@ti.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: balbi@ti.com, linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Date: Wed, 08 Feb 2012 13:25:19 +0200
In-Reply-To: <CAM=Q2cvZWdUk-v4-EWUJzAf4br-4+tO2s3qS_dn4KhHp+mm2+g@mail.gmail.com>
References: <1328698612-18661-1-git-send-email-coelho@ti.com>
	 <20120208105957.GB16334@legolas.emea.dhcp.ti.com>
	 <1328699077.20197.51.camel@cumari>
	 <CAM=Q2cvZWdUk-v4-EWUJzAf4br-4+tO2s3qS_dn4KhHp+mm2+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 16:42 +0530, Shubhrajyoti Datta wrote: 
> On Wed, Feb 8, 2012 at 4:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Wed, 2012-02-08 at 12:59 +0200, Felipe Balbi wrote:
> >> On Wed, Feb 08, 2012 at 12:56:52PM +0200, Luciano Coelho wrote:
> >> > Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building
> >>
> >> we generally like to see the commit subject here too. And adding the
> >> abbreviated commit instead of the full sha1, wouldn't hurt either ;-)
> >
> > Ok, different practices. :)
> 
> However  there was already a discurssion.
> Anyways thanks for the patch.
> http://permalink.gmane.org/gmane.linux.ports.arm.omap/69796
> 
> 
> >
> > I'll send v2.
> I think there was already a fix for this.
> 
> http://www.spinics.net/lists/linux-omap/msg63151.html
> 
> Anyways thanks for the patch.

Ah, okay.  Thanks for the info, I hadn't seen these.

-- 
Cheers,
Luca.

