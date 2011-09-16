Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1IPNGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:06:16 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:49136 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1IPNGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:06:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ravi, Deepthy" <deepthy.ravi@ti.com>
Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
Date: Fri, 16 Sep 2011 15:06:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.1; x86_64; ; )
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
References: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com> <201109081921.28051.laurent.pinchart@ideasonboard.com> <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D09083D@dbde03.ent.ti.com>
In-Reply-To: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D09083D@dbde03.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109161506.16505.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Deepthy,

On Friday 16 September 2011 15:00:53 Ravi, Deepthy wrote:
> On Thursday, September 08, 2011 10:51 PM Laurent Pinchart wrote: 
> > On Thursday 08 September 2011 15:35:22 Deepthy Ravi wrote:
> >> From: Vaibhav Hiremath <hvaibhav@ti.com>
> >> 
> >> In order to support TVP5146 (for that matter any video decoder),
> >> it is important to support G/S/ENUM_STD ioctl on /dev/videoX
> >> device node.
> > 
> > Why so ? Shouldn't it be queried on the subdev output pad directly ?
> 
> Because standard v4l2 application for analog devices will call these std
> ioctls on the streaming device node. So it's done on /dev/video to make the
> existing apllication work.

Existing applications can't work with the OMAP3 ISP (and similar complex 
embedded devices) without userspace support anyway, either in the form of a 
GStreamer element or a libv4l plugin. I still believe that analog video 
standard operations should be added to the subdev pad operations and exposed 
through subdev device nodes, exactly as done with formats.

-- 
Regards,

Laurent Pinchart
