Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab2AKAxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:53:35 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33002
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757282Ab2AKAxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:53:34 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dhc1ahc1bh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 11 Jan 2012 08:53:23 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Richard Zhao <richard.zhao@linaro.org>, <patches@linaro.org>,
        <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <eric.miao@linaro.org>, <kernel@pengutronix.de>,
        <dan.j.williams@intel.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] dma/imx-sdma: check whether event_id0 < 32 when set
 event_mask
Message-ID: <20120111005322.GB2414@b20223-02.ap.freescale.net>
References: <1326178910-14044-1-git-send-email-richard.zhao@linaro.org>
 <1326178910-14044-6-git-send-email-richard.zhao@linaro.org>
 <20120110142008.GE26599@S2101-09.ap.freescale.net>
 <20120110142939.GB2019@richard-laptop>
 <20120110153836.GA27831@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120110153836.GA27831@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 11:38:39PM +0800, Shawn Guo wrote:
> On Tue, Jan 10, 2012 at 10:29:42PM +0800, Richard Zhao wrote:
> > On Tue, Jan 10, 2012 at 10:20:10PM +0800, Shawn Guo wrote:
> > > On Tue, Jan 10, 2012 at 03:01:50PM +0800, Richard Zhao wrote:
> > > > Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> > > > ---
> > > 
> > > I think it deserves a sensible commit message explaining why the patch
> > > is needed.
> > If event_id0 < 32, 1 << (sdmac->event_id0 - 32) is not zero.
This meant to make you clear about the patch. I'll add it in commit
message.
> > 
> My point is you may explain the exact problem you are seeing without
> this patch
The kernel don't have event_id < 32 case yet. I found the bug when
I review the code.
> and how the patch helps here.  In general, doing so would
> win a warm feeling from reviewers much more easily than leaving the
> commit message empty there.
I understand your point that comment as much as possible.

Thanks
Richard
> 
> -- 
> Regards,
> Shawn
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

