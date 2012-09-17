Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2IQPvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:51:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27818 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2IQPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:51:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6838"; a="237633913"
Date: Mon, 17 Sep 2012 08:51:02 -0700
From: David Brown <davidb@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, grant.likely@secretlab.ca,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio_msm: using for_each_set_bit to simplify the code
Message-ID: <20120917155102.GA12210@codeaurora.org>
References: <CAPgLHd-ScAsYQnag6ix7En+XCmEmatw8S2+w-ih9uqUdv1fqXQ@mail.gmail.com>
 <CACRpkdbnawDdmwoY5CS8Sd-ZyN0hfx8fa7gdjPmESwpsp2dCVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbnawDdmwoY5CS8Sd-ZyN0hfx8fa7gdjPmESwpsp2dCVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:54:45PM +0200, Linus Walleij wrote:
> On Fri, Sep 14, 2012 at 4:28 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Using for_each_set_bit() to simplify the code.
> >
> > spatch with a semantic match is used to found this.
> > (http://coccinelle.lip6.fr/)
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> David, does this patch look OK from your point of view?

It appears to.  Rohit Vaswani is doing some work on this driver, so
I've also forwarded the patch to him.

Acked-by: David Brown <davidb@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
