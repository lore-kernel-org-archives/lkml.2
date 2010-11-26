Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0KZOOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:14:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46847 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751043Ab0KZOOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:14:43 -0500
Date: Fri, 26 Nov 2010 14:14:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        lennart@poettering.net
Subject: Re: [RFC/PATCH v6 03/12] media: Entities, pads and links
Message-ID: <20101126141442.GI30360@rakim.wolfsonmicro.main>
References: <1290652099-15102-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201011251640.42206.laurent.pinchart@ideasonboard.com>
 <20101125154952.GJ22298@rakim.wolfsonmicro.main>
 <201011261513.37491.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011261513.37491.laurent.pinchart@ideasonboard.com>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 03:13:36PM +0100, Laurent Pinchart wrote:
> On Thursday 25 November 2010 16:49:52 Mark Brown wrote:
> > On Thu, Nov 25, 2010 at 04:40:41PM +0100, Laurent Pinchart wrote:

> > > It's supposed to reflect whether the link can carry data. Think of the
> > > active flag as a valve on a pipe. If the valve is open, the link is
> > > active. If the valve is closed, the link is inactive. This is unrelated
> > > to whether water actually flows through the pipe.

> > This seems a confusing name, then - I'd expect an active link to be one
> > which is actually carrying data rather than one which is available to
> > carry data.  How a more neutrally worded name such as "connected" (which
> > is what ASoC uses currently)?

> In our current vocabulary "connected" refers to entities between which a link 
> exist, regardless of the link state ("valve opened" or "valve closed"). I'm 
> not totally happy with "active" either, but if we replace it with "connected" 
> we need another word to replace current uses of "connected".

Linked?
