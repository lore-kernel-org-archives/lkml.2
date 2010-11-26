Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0KZOHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:07:37 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:40863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab0KZOHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:07:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 00/12] Media controller (core and V4L2)
Date: Fri, 26 Nov 2010 15:07:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1; KDE/4.5.3; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        sakari.ailus@maxwell.research.nokia.com, lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <20101125142803.GA15099@sirena.org.uk>
In-Reply-To: <20101125142803.GA15099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011261507.30191.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thursday 25 November 2010 15:28:04 Mark Brown wrote:
> On Thu, Nov 25, 2010 at 03:28:07AM +0100, Laurent Pinchart wrote:
> > I want to emphasize that the media controller API does *not* replace the
> > V4L, DVB or ALSA APIs. It complements them.
> 
> Overall this looks relatively good and should be mappable onto the
> embedded audio stack.

Thanks a lot for the review.

> I'd need to sit down and actually do that to go into too much specific
> detail but the only real issue I see is working out how the control aspects
> of this interact with the control in ALSA. The simplest thing would be to
> have the userspace API be read only for ALSA devices, I guess.

That sounds good, especially for the first step.

-- 
Regards,

Laurent Pinchart
