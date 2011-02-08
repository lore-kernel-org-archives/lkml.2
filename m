Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1BHNfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:35:22 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:38634 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab1BHNfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:35:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v8 03/12] media: Entities, pads and links
Date: Tue, 8 Feb 2011 14:35:14 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.36-gentoo-r3; KDE/4.6.0; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, clemens@ladisch.de
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com> <201102041120.37541.hverkuil@xs4all.nl>
In-Reply-To: <201102041120.37541.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081435.15911.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Friday 04 February 2011 11:20:37 Hans Verkuil wrote:
> On Thursday, January 27, 2011 13:30:28 Laurent Pinchart wrote:

<snip>

> > +#define MEDIA_ENT_TYPE_SHIFT		16
> > +#define MEDIA_ENT_TYPE_MASK		0x00ff0000
> > +#define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
> > +
> > +#define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENTITY_TYPE_SHIFT)
> > +#define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENTITY_T_DEVNODE + 1)
> > +#define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENTITY_T_DEVNODE + 2)
> > +#define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENTITY_T_DEVNODE + 3)
> > +#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENTITY_T_DEVNODE + 4)
> > +
> > +#define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENTITY_TYPE_SHIFT)
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENTITY_T_V4L2_SUBDEV + 1)
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENTITY_T_V4L2_SUBDEV + 2)
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENTITY_T_V4L2_SUBDEV + 3)
> 
> MEDIA_ENTITY_? That should be MEDIA_ENT_. It looks like this was never
> compiled...

Oops. I probably forgot to compile this intermediate patch (the end result is 
correct though). I'll fix it.

-- 
Regards,

Laurent Pinchart
