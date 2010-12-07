Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0LGSLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:11:50 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4505 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab0LGSLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:11:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Tue, 7 Dec 2010 19:11:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <201012071813.35501.hverkuil@xs4all.nl> <20101207175505.GI9689@rakim.wolfsonmicro.main>
In-Reply-To: <20101207175505.GI9689@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071911.39270.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 07, 2010 18:55:05 Mark Brown wrote:
> On Tue, Dec 07, 2010 at 06:13:35PM +0100, Hans Verkuil wrote:
> 
> > Personally I think this is perfectly clear. The original confusion came from
> > the word 'active', which I understand means 'streaming' in alsa. By adding
> > a 'streaming' flag in addition to the active flag I think it will be clear
> > that 'active' and 'streaming' are two different things.
> 
> It's not that, it's the fact that active sounds to me like the link
> ought to be powered up which isn't the case - it's too verby.  Like I
> say, I think I'd prefer a more passive name like "connected".

Ah, now I understand what you mean. Would 'activated' be better than 'active'?

Or perhaps just say: the link 'is on' or the link 'is switched on'?

So: ...LINK_SWITCHED_ON (sorry, forgot what the prefix is).

Actually, I think 'switched on' is a pretty good description of what is going on
in the hardware.

Regards,

	Hans
 
> I guess if nobody else finds it confusing I can live with it.
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
