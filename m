Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2DWXJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:09:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12214 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2DWXJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:09:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6690"; a="181997140"
Date: Mon, 23 Apr 2012 16:09:49 -0700
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: msm: Fix gic irqdomain support
Message-ID: <20120423230949.GA31173@codeaurora.org>
References: <1335221222-30879-1-git-send-email-davidb@codeaurora.org>
 <CACxGe6sPkW8WviMX=oJEj+-G7XMeaWaQYfe_hg2quB-Sh2gEDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6sPkW8WviMX=oJEj+-G7XMeaWaQYfe_hg2quB-Sh2gEDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 04:55:11PM -0600, Grant Likely wrote:
> On Mon, Apr 23, 2012 at 4:47 PM, David Brown <davidb@codeaurora.org> wrote:
> > As of
> >
> >    commit 75294957be1dee7d22dd7d90bd31334ba410e836
> >    Author: Grant Likely <grant.likely@secretlab.ca>
> >    Date:   Tue Feb 14 14:06:57 2012 -0700
> >
> >        irq_domain: Remove 'new' irq_domain in favour of the ppc one
> >
> > the ARM gic controller uses proper irq domains.  Fix the MSM gic
> > initialization and DT so that it works again.
> >
> > Signed-off-by: David Brown <davidb@codeaurora.org>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> This should go via the arm-soc tree I think

I was planning on going that route.

Thanks

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
