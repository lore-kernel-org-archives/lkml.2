Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0H0TBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:01:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56414 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752793Ab0H0TBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:01:16 -0400
Date: Fri, 27 Aug 2010 20:01:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: soc-core: fix debugfs_pop_time file permissions
Message-ID: <20100827190126.GA6666@opensource.wolfsonmicro.com>
References: <1282876467.9142.2.camel@mola>
 <1282911900.3025.7.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282911900.3025.7.camel@odin>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 01:25:00PM +0100, Liam Girdwood wrote:
> On Fri, 2010-08-27 at 10:34 +0800, Axel Lin wrote:
> > I think this is a typo, debugfs_pop_time should not be executable.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>

> Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>

Applied, thanks.
