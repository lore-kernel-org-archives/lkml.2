Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0LNNtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:49:22 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35723 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759026Ab0LNNtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:49:20 -0500
X-Sasl-enc: Y/AR+UrCaCCVypk4DPA4j7OHF3xBhiIdKApKdFce3K7w 1292334559
Message-ID: <4D0775DB.2020902@ladisch.de>
Date: Tue, 14 Dec 2010 14:49:15 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, alsa-devel@alsa-project.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [RFC/PATCH v6 03/12] media: Entities, pads and links
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012141300.57118.laurent.pinchart@ideasonboard.com> <e629c78fffa0f709d743473f10334fd7.squirrel@webmail.xs4all.nl> <201012141353.15749.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012141353.15749.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> On Tuesday 14 December 2010 13:40:21 Hans Verkuil wrote:
>> > On Monday 13 December 2010 17:10:51 Clemens Ladisch wrote:
>> >> * Entity types
>> >> 
>> >> TYPE_NODE was renamed to TYPE_DEVICE because "node" sounds like a node
>> >> in a graph, which does not distinguish it from other entity types
>> >> because all entities are part of the topology graph.  I chose "device"
>> >> as this type describes entities that are visible as some device node to
>> >> other software.
>> > 
>> > What this type describes is a device node. Both NODE and DEVICE can be
>> > confusing in my opinion, but DEVICE_NODE is a bit long.
>> 
>> What about DEVNODE? I think that would be a good alternative.
> 
> Fine with me. Clemens, any opinion on that ?

Fine with me too.

> > >> TYPE_EXT describes entities that represent some interface to the
> > >> external world, TYPE_INT those that are internal to the entire device.
> > >> (I'm not sure if that distinction is very useful, but TYPE_SUBDEV seems
> > >> to be an even more meaningless name.)
> > > 
> > > SUBDEV comes from the V4L2 world, and I agree that it might not be a very
> > > good name.
> > 
> > SUBDEV refers to a specific type of driver. Within the v4l world it is
> > well defined. So I prefer to keep this. Perhaps some additional comments
> > or documentation can be added to clarify this.
> 
> Should this be clarified by using V4L2_SUBDEV instead then ?

If the "SUBDEV" concept doesn't exist outside V4L, that would indeed be
better.

I don't want to rename things that come out of existing frameworks; this
naming discussion makes sense only for those entity (sub)types that can
be shared between them.  Are there any, besides jacks?

> What about ALSA entities, should they use MEDIA_ENTITY_TYPE_ALSA_* ?

The entity types representing ALSA devices are already named "ALSA".


Regards,
Clemens
