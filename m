Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2ASIog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:44:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab2ASIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:44:13 -0500
Date: Thu, 19 Jan 2012 16:55:42 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH resent v2 1/2] ioport : add DEFINE_RES_DMA_SIZE_NAMED
 macro
Message-ID: <20120119085539.GG2247@S2101-09.ap.freescale.net>
References: <1326959620-25920-1-git-send-email-b32955@freescale.com>
 <1326959620-25920-2-git-send-email-b32955@freescale.com>
 <20120119081427.GF2247@S2101-09.ap.freescale.net>
 <4F17D2ED.6090502@freescale.com>
 <4F17D40F.3080803@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F17D40F.3080803@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 04:27:59PM +0800, Huang Shijie wrote:
> 
> >Hi Shawn:
> >>I'm not sure the patch is welcomed.  You may want to just use
> >>DEFINE_RES_NAMED for such cases.
> >I ever wanted to use DEFINE_RES_NAMED.
> sorry. I misunderstood your meaning.
> 
> I think it's better to add a new macro. use DEFINE_RES_NAMED is not proper.
> 
In that case, I can not apply the patch #2 until #1 hits mainline, so
remember to ping me for applying patch #2 when the first one gets
merged.

-- 
Regards,
Shawn
