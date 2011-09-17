Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1IQVgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 17:36:11 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1IQVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 17:36:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Proposal for a low-level Linux display framework
Date: Sat, 17 Sep 2011 23:36:07 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.1; x86_64; ; )
Cc: Keith Packard <keithp@keithp.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
        "Clark\, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
References: <1316088425.11294.78.camel@lappyti> <yun8vpp7qk7.fsf@aiko.keithp.com> <20110915180500.53c70206@lxorguk.ukuu.org.uk>
In-Reply-To: <20110915180500.53c70206@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109172336.08624.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 September 2011 19:05:00 Alan Cox wrote:
> On Thu, 15 Sep 2011 10:50:32 -0500
> Keith Packard wrote:
> > On Thu, 15 Sep 2011 18:29:54 +0300, Tomi Valkeinen wrote:
> > > 1) It's part of DRM, so it doesn't help fb or v4l2 drivers. Except if
> > > the plan is to make DRM the core Linux display framework, upon which
> > > everything else is built, and fb and v4l2 are changed to use DRM.
> > 
> > I'd like to think we could make DRM the underlying display framework;
> > it already exposes an fb interface, and with overlays, a bit more of the
> > v4l2 stuff is done as well. Certainly eliminating three copies of mode
> > setting infrastructure would be nice...
> 
> V4L2 needs to interface with the DRM anyway. Lots of current hardware
> wants things like shared 1080i/p camera buffers with video in order to do
> preview on video and the like.

Buffers sharing is a hot topic that has been discussed during Linaro Connect 
in August 2011. Even though the discussions were aimed at solving ARM-related 
embedded issues, the solution we're working on is not limited to the ARM 
platform and will allow applications to pass buffers around between device 
drivers from different subsystems.

> In my semi-perfect world vision fb would be a legacy layer on top of DRM.
> DRM would get the silly recovery fail cases fixed, and a kernel console
> would be attachable to a GEM object of your choice.

-- 
Regards,

Laurent Pinchart
