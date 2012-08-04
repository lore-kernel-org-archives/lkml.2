Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab2HFKXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:23:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34965 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485Ab2HFKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:23:16 -0400
Date: Sat, 4 Aug 2012 15:30:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] regmap: Add regmap dummy driver
Message-ID: <20120804143029.GC15691@opensource.wolfsonmicro.com>
References: <1343397500-31283-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <20120804100522.GC9248@opensource.wolfsonmicro.com>
 <20120804124342.GA7700@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120804124342.GA7700@opensource.wolfsonmicro.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 01:43:42PM +0100, Dimitris Papastamos wrote:
> On Sat, Aug 04, 2012 at 11:05:23AM +0100, Mark Brown wrote:

> > Any reason not to put this in the tools directory?

> At the moment the repo is very bare bones.  I was thinking more of
> an automated testing framework written in sh or similar.  So it might
> grow out into its own repository anyhow.

It'd need to be pretty enormous for that I'd expect.

> > All these functions just seem to be implementing the default behaviour,
> > why are they needed?

> Hm will remove them for now but it would be useful for these to be set by
> the user via debugfs or similar.  These were mainly stubs for that sort
> of thing.

I figured that was the idea but until there's code controlling them it's
better to just not have anything.
