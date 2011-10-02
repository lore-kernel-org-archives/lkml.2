Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1JBRTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 13:19:00 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:43763 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1JBRS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 13:18:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: 3.1-rc8 still references 2.6.42 when ioctls will be removed
Date: Sun, 2 Oct 2011 19:19:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.1; x86_64; ; )
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <alpine.DEB.2.02.1110020640390.3972@p34.internal.lan> <4E889839.30005@xenotime.net>
In-Reply-To: <4E889839.30005@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110021919.01918.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Sunday 02 October 2011 18:58:33 Randy Dunlap wrote:
> On 10/02/11 03:41, Justin Piszcz wrote:
> > Hi,
> > 
> > FYI--
> > 
> > [   48.519528] uvcvideo: Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
> > ioctls will be removed in 2.6.42.
> > 
> > $ grep 2.6.42 -r /usr/src/linux/*
> > 
> > /usr/src/linux/drivers/media/video/uvc/uvc_v4l2.c:                
> > "ioctls will be removed in 2.6.42.\n");
> 
> Let's tell the linux-media & Laurent.
> 
> But linux-next does not contain that line nor that function.
> I guess something in linux-next needs to be merged into mainline.

2.6.42 being 3.2, I've sent a patch to remove the deprecated ioctls. Mauro has 
applied it to his tree and will push it to Linus for v3.2.

-- 
Regards,

Laurent Pinchart
