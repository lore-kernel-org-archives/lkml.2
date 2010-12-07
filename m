Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab0LGRzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:55:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51404 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751872Ab0LGRzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:55:08 -0500
Date: Tue, 7 Dec 2010 17:55:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Message-ID: <20101207175505.GI9689@rakim.wolfsonmicro.main>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201012031450.59137.laurent.pinchart@ideasonboard.com>
 <20101203145408.GW859@rakim.wolfsonmicro.main>
 <201012071813.35501.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012071813.35501.hverkuil@xs4all.nl>
X-Cookie: E Pluribus Unix
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 06:13:35PM +0100, Hans Verkuil wrote:

> Personally I think this is perfectly clear. The original confusion came from
> the word 'active', which I understand means 'streaming' in alsa. By adding
> a 'streaming' flag in addition to the active flag I think it will be clear
> that 'active' and 'streaming' are two different things.

It's not that, it's the fact that active sounds to me like the link
ought to be powered up which isn't the case - it's too verby.  Like I
say, I think I'd prefer a more passive name like "connected".

I guess if nobody else finds it confusing I can live with it.
