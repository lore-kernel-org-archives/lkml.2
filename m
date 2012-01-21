Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab2AUSfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:35:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab2AUSfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:35:15 -0500
Date: Sat, 21 Jan 2012 18:35:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 4/14] kernel-doc: fix new warning in regulator core
Message-ID: <20120121183512.GF10751@opensource.wolfsonmicro.com>
References: <4F1B0BCE.4050505@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1B0BCE.4050505@xenotime.net>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 11:02:38AM -0800, Randy Dunlap wrote:

> @@ -2731,6 +2731,7 @@ static void rdev_init_debugfs(struct reg
>   * @dev: struct device for the regulator
>   * @init_data: platform provided init data, passed through by driver
>   * @driver_data: private regulator data
> + * @of_node: target of device structure (may be NULL)

Please don't apply this, I can't actually parse that description so I'm
fairly sure users will struggle also.  I'll try to get round to writing
something better at some point.
