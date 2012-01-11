Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2AKNAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:00:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59032 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2AKNAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:00:52 -0500
Date: Wed, 11 Jan 2012 21:11:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>, patches@linaro.org,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        eric.miao@linaro.org, kernel@pengutronix.de, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set
 event_mask
Message-ID: <20120111131134.GB20968@S2101-09.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
 <20120110142008.GE26599@S2101-09.ap.freescale.net>
 <20120110142939.GB2019@richard-laptop>
 <20120110153836.GA27831@S2101-09.ap.freescale.net>
 <20120111005322.GB2414@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111005322.GB2414@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 08:53:23AM +0800, Richard Zhao wrote:
> The kernel don't have event_id < 32 case yet. I found the bug when
> I review the code.

I tested audio on imx51, in which case SSI0 TX event number is 29.
I do not see any problem without applying this patch.

-- 
Regards,
Shawn
