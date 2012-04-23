Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2DWMcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:32:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:52708 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab2DWMcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:32:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134168591"
Subject: Re: [PATCHv3] dma40: Improve the logic of stopping logical chan
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Narayanan G <narayanan.gopalakrishnan@stericsson.com>,
        linux-kernel@vger.kernel.org, rabin.vincent@stericsson.com,
        linus.walleij@stericsson.com, shreshthakumar.sahu@stericsson.com,
        mathieu poirier <mathieu.poirier@linaro.org>
In-Reply-To: <CACRpkdaXRJVtqgnrkuJ8YUPDp3QSPQR9LmAX=ePdYxzZagKa=w@mail.gmail.com>
References: <1328771497-3032-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
	 <CACRpkdaXRJVtqgnrkuJ8YUPDp3QSPQR9LmAX=ePdYxzZagKa=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 17:59:17 +0530
Message-ID: <1335184157.31825.111.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 10:12 +0200, Linus Walleij wrote:
> On Thu, Feb 9, 2012 at 8:11 AM, Narayanan G
> <narayanan.gopalakrishnan@stericsson.com> wrote:
> 
> > From the V2 version of the controller a logical channel
> > can be directly stopped by issuing a SUSPEND_REQ on the EE
> > bits. There is no need to suspend the physical channel and
> > restart it.
> >
> > Also, the support for pre-V2 hw is discontinued.
> >
> > EE bits for writing:
> >
> > 00: disable only if AS=11 or AS=00
> > 01: enable
> > 10: suspend_req only if AS=01 & EE=01 or EE=11
> > 11: round / no change for writing
> >
> > Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Vinod what happened to this patch?
> 
> Can you please push it for the -rc:s since it's solving a real problem
> for us...
Sorry, Looks like it got missed.
Applied now, Thanks


-- 
~Vinod

