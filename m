Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1ITXxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 19:53:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52355 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033Ab1ITXxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 19:53:03 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sAiMjbRkx4KMfgxR129B4
Date: Tue, 20 Sep 2011 16:52:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Deepthy Ravi <deepthy.ravi@ti.com>, mchehab@infradead.org, hvaibhav@ti.com,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
        santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        david.woodhouse@intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 5/5] omap2plus_defconfig: Enable omap3isp and MT9T111
 sensor drivers
Message-ID: <20110920235254.GM2937@atomide.com>
References: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
 <1316530612-23075-6-git-send-email-deepthy.ravi@ti.com>
 <201109210113.49151.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109210113.49151.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [110920 15:40]:
> >  CONFIG_REGULATOR_TPS65023=y
> >  CONFIG_REGULATOR_TPS6507X=y
> > +CONFIG_MEDIA_SUPPORT=y
> > +CONFIG_MEDIA_CONTROLLER=y
> > +CONFIG_VIDEO_DEV=y
> > +CONFIG_VIDEO_V4L2_COMMON=y
> > +CONFIG_VIDEO_ALLOW_V4L1=y
> > +CONFIG_VIDEO_V4L1_COMPAT=y
> > +CONFIG_VIDEO_V4L2_SUBDEV_API=y
> > +CONFIG_VIDEO_MEDIA=y
> > +CONFIG_VIDEO_MT9T111=y
> > +CONFIG_VIDEO_OMAP3=y
> 
> Shouldn't they be compiled as modules instead ?

Yes, let's not apply this.

Tony
