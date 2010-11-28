Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0K1P5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 10:57:31 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4069 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0K1P50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 10:57:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Date: Sun, 28 Nov 2010 16:57:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com> <20101126141442.GI30360@rakim.wolfsonmicro.main> <201011281334.46386.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011281334.46386.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011281657.00408.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 28, 2010 13:34:45 Laurent Pinchart wrote:
> Hi Mark,
> 
> On Friday 26 November 2010 15:14:42 Mark Brown wrote:
> > On Fri, Nov 26, 2010 at 03:13:36PM +0100, Laurent Pinchart wrote:
> > > On Thursday 25 November 2010 16:49:52 Mark Brown wrote:
> > > > On Thu, Nov 25, 2010 at 04:40:41PM +0100, Laurent Pinchart wrote:
> > > > > It's supposed to reflect whether the link can carry data. Think of
> > > > > the active flag as a valve on a pipe. If the valve is open, the link
> > > > > is active. If the valve is closed, the link is inactive. This is
> > > > > unrelated to whether water actually flows through the pipe.
> > > > 
> > > > This seems a confusing name, then - I'd expect an active link to be one
> > > > which is actually carrying data rather than one which is available to
> > > > carry data.  How a more neutrally worded name such as "connected"
> > > > (which is what ASoC uses currently)?
> > > 
> > > In our current vocabulary "connected" refers to entities between which a
> > > link exist, regardless of the link state ("valve opened" or "valve
> > > closed"). I'm not totally happy with "active" either, but if we replace
> > > it with "connected" we need another word to replace current uses of
> > > "connected".
> > 
> > Linked?
> 
> That's a good option. Hans, do you want to comment on this ?
> 
> 

Fine by me! It's better than 'active'.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
