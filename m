Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab2AJP2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 10:28:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36539 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2AJP17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 10:27:59 -0500
Date: Tue, 10 Jan 2012 23:38:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        eric.miao@linaro.org, patches@linaro.org
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set
 event_mask
Message-ID: <20120110153836.GA27831@S2101-09.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
 <20120110142008.GE26599@S2101-09.ap.freescale.net>
 <20120110142939.GB2019@richard-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110142939.GB2019@richard-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 10:29:42PM +0800, Richard Zhao wrote:
> On Tue, Jan 10, 2012 at 10:20:10PM +0800, Shawn Guo wrote:
> > On Tue, Jan 10, 2012 at 03:01:50PM +0800, Richard Zhao wrote:
> > > Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> > > ---
> > 
> > I think it deserves a sensible commit message explaining why the patch
> > is needed.
> If event_id0 < 32, 1 << (sdmac->event_id0 - 32) is not zero.
> 
My point is you may explain the exact problem you are seeing without
this patch and how the patch helps here.  In general, doing so would
win a warm feeling from reviewers much more easily than leaving the
commit message empty there.

-- 
Regards,
Shawn
