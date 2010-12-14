Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0LNPap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:30:45 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37921 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757219Ab0LNPao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:30:44 -0500
X-Sasl-enc: +XgDzJ1X7qK0irDIZZR1cQjOUfMwLoQygd8AgbFWqunQ 1292340642
Message-ID: <4D078D9F.1060700@ladisch.de>
Date: Tue, 14 Dec 2010 16:30:39 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: alsa-devel@alsa-project.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities,	pads and links
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>	<201012141300.57118.laurent.pinchart@ideasonboard.com>	<4D0771CB.3020809@ladisch.de> <201012141525.02463.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012141525.02463.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> On Tuesday 14 December 2010 14:31:55 Clemens Ladisch wrote:
> > Laurent Pinchart wrote:
> > > On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
> > >> EXT_SPEAKER also includes headphones; there might be made a case for
> > >> having those as a separate subtype.
> > > 
> > > Shouldn't headphones be represented by an EXT_JACK_ANALOG ?
> > 
> > Headphone jacks are jacks; there are also USB headphones.
> 
> So EXT_SPEAKER are speakers not connected through a jack (USB, internal
> analog, ...) ?

Yes.

When there is jack, the driver often does not know what is connected.

> > >> EXT_BROADCAST represents devices like TV tuners, satellite receivers,
> > >> cable tuners, or radios.
> > > 
> > > There's clearly an overlap with V4L here.
> > 
> > These come from the USB audio spec.  Video devices are indeed likely to
> > be more detailed than just a single audio source. :)
> 
> Does EXT_BROADCAST represent the TV tuner (or satellite receiver, cable tuner,
> radio tuner, ...) itself, or the connection between the tuner and the rest of
> the device ? Most TV tuner are currently handled by V4L2 and would thus turn
> up as V4L2 subdevs (I'm not sure if that's what we want in the long term, but
> it's at least the current situation).

>From the point of view of an audio device, this would be just some audio
source, much like a connector.  We don't need this if there is some
better V4L entitity that the USB audio entity can be mapped to.


Regards,
Clemens
