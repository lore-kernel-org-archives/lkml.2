Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0LWJF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:05:27 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:42408 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0LWJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:05:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v7 03/12] media: Entities, pads and links
Date: Thu, 23 Dec 2010 10:05:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, gregkh@suse.de,
        sakari.ailus@maxwell.research.nokia.com
References: <1292844995-7900-1-git-send-email-laurent.pinchart@ideasonboard.com> <1292844995-7900-4-git-send-email-laurent.pinchart@ideasonboard.com> <201012211722.39810.hverkuil@xs4all.nl>
In-Reply-To: <201012211722.39810.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231005.34882.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tuesday 21 December 2010 17:22:39 Hans Verkuil wrote:
> Hi Laurent,
> 
> I promised to look at the new type names, so here is my opinion:

Thanks.

> On Monday, December 20, 2010 12:36:26 Laurent Pinchart wrote:
> 
> <snip>
> 
> > +
> > +#define MEDIA_ENTITY_TYPE_SHIFT			16
> > +#define MEDIA_ENTITY_TYPE_MASK			0x00ff0000
> > +#define MEDIA_ENTITY_SUBTYPE_MASK		0x0000ffff
> > +
> > +#define MEDIA_ENTITY_TYPE_DEVNODE		(1 << MEDIA_ENTITY_TYPE_SHIFT)
> > +#define MEDIA_ENTITY_TYPE_DEVNODE_V4L		(MEDIA_ENTITY_TYPE_DEVNODE + 
1)
> > +#define MEDIA_ENTITY_TYPE_DEVNODE_FB		(MEDIA_ENTITY_TYPE_DEVNODE + 2)
> > +#define MEDIA_ENTITY_TYPE_DEVNODE_ALSA		(MEDIA_ENTITY_TYPE_DEVNODE + 
3)
> > +#define MEDIA_ENTITY_TYPE_DEVNODE_DVB		(MEDIA_ENTITY_TYPE_DEVNODE + 
4)
> > +
> > +#define MEDIA_ENTITY_TYPE_V4L2_SUBDEV		(2 << MEDIA_ENTITY_TYPE_SHIFT)
> > +#define
> > MEDIA_ENTITY_TYPE_V4L2_SUBDEV_SENSOR	(MEDIA_ENTITY_TYPE_V4L2_SUBDEV + 1)
> > +#define
> > MEDIA_ENTITY_TYPE_V4L2_SUBDEV_FLASH	(MEDIA_ENTITY_TYPE_V4L2_SUBDEV + 2)
> > +#define
> > MEDIA_ENTITY_TYPE_V4L2_SUBDEV_LENS	(MEDIA_ENTITY_TYPE_V4L2_SUBDEV + 3) +
> > +#define MEDIA_ENTITY_FLAG_DEFAULT		(1 << 0)
> > +
> > +#define MEDIA_LINK_FLAG_ENABLED			(1 << 0)
> > +#define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
> > +
> > +#define MEDIA_PAD_FLAG_INPUT			(1 << 0)
> > +#define MEDIA_PAD_FLAG_OUTPUT			(1 << 1)
> 
> Using V4L2_SUBDEV instead of just SUBDEV is definitely an improvement.
> 
> However, I think the defines are getting way too long and I would propose
> to use the ME_ prefix instead of MEDIA_ENTITY_. Also ML_ instead of
> MEDIA_LINK_ and MP_ instead of MEDIA_PAD_.
> 
> That way it is less of an alphabet soup when reading code.

I agree that the names are too long, but I'm concerned that the ME_, ML_ and 
MP_ prefixes might cause namespace clashes.

-- 
Regards,

Laurent Pinchart
