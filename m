Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2KOJ6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:58:04 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:50183 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756572Ab2KOJ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:58:01 -0500
Date: Thu, 15 Nov 2012 15:27:42 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "chuansheng.liu@intel.com" <chuansheng.liu@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH 1/7] I2c-nomadik: Fix the usage of
 wait_for_completion_timeout
Message-ID: <20121115095741.GA6280@bnru10>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
 <CACRpkdYekQF5111NSNSPeaHdxgS_gpXkCjqT1n-n1_iAdDXbSg@mail.gmail.com>
 <20121115084858.GA29668@bnru10>
 <20121115092953.GA418@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121115092953.GA418@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 10:29:53 +0100, Wolfram Sang wrote:
> 
> > > -       if (timeout < 0) {
> > > -               dev_err(&dev->adev->dev,
> > > -                       "wait_for_completion_timeout "
> > > -                       "returned %d waiting for event\n", timeout);
> > > -               status = timeout;
> > > -       }
> > > -
> > No, it is wrong. You need to update the status variable in the case of timeout.
> 
> Looking at the patch context, such code comes later.
But it causes regressions; without looking at the "later" code, we can't afford merging
this code now.

regards/srinidhi
