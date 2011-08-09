Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab1HIEhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 00:37:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:57416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1HIEhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 00:37:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,341,1309762800"; 
   d="scan'208";a="36539925"
Subject: Re: [PATCH] dmaengine: pl330: add missing include of scatterlist.h
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jassi Brar <jassisinghbrar@gmail.com>
In-Reply-To: <CABb+yY2bt0M0X0o-2578eBcP7vwvjykCykKv6e0+HZ17Qset_w@mail.gmail.com>
References: <1312830866-2932-1-git-send-email-robherring2@gmail.com>
	 <CABb+yY2bt0M0X0o-2578eBcP7vwvjykCykKv6e0+HZ17Qset_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 10:06:18 +0530
Message-ID: <1312864578.1539.46.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 00:59 +0530, Jassi Brar wrote:
> On Tue, Aug 9, 2011 at 12:44 AM, Rob Herring <robherring2@gmail.com> wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> >
> > scatterlist.h was getting implicitly included and now is not which
> > causes this compile error:
> >
> > drivers/dma/pl330.c: In function ‘pl330_prep_slave_sg’:
> > drivers/dma/pl330.c:603:2: error: implicit declaration of function
> > ‘for_each_sg’
> >
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Jassi Brar <jassisinghbrar@gmail.com>
> > Cc: Vinod Koul <vkoul@infradead.org>
> 
> Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
> 
> thnx

Commit 90b44f8 introduces dmaengine_prep_slave_single API which adds
scatterlist.h in dmaengine.h, since you already include dmaengine.h this
patch shouldn't be required

-- 
~Vinod

