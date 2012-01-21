Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2AULHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 06:07:53 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:54677 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2AULHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 06:07:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] [media] convert drivers/media/* to use module_i2c_driver()
Date: Sat, 21 Jan 2012 12:07:50 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Andrew Chew <achew@nvidia.com>, Paul Mundt <lethal@linux-sh.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Johannes Obermaier <johannes.obermaier@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
References: <1327140645.3928.1.camel@phoenix>
In-Reply-To: <1327140645.3928.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201211207.52778.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Thanks for the patch.

On Saturday 21 January 2012 11:10:45 Axel Lin wrote:
> This patch converts the drivers in drivers/media/* to use the
> module_i2_driver() macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

For the following modules,

>  drivers/media/video/adp1653.c                 |   19 +----------------
>  drivers/media/video/as3645a.c                 |   19 +----------------
>  drivers/media/video/mt9p031.c                 |   13 +----------
>  drivers/media/video/mt9t001.c                 |   13 +----------
>  drivers/media/video/mt9v032.c                 |   13 +----------

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
