Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1GZNtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:49:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1GZNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:49:08 -0400
Subject: Re: [PATCH v2] dmaengine: pl330: make platform data optional
From: Vinod Koul <vkoul@infradead.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: vinod.koul@intel.com, Rob Herring <robherring2@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <CABb+yY1BydX=YMe_nenkYr+bsH-3k3gObO3qav5AA5DrxMP=2Q@mail.gmail.com>
References: <1310518811-379-1-git-send-email-robherring2@gmail.com>
	 <1311627904-24045-1-git-send-email-robherring2@gmail.com>
	 <CABb+yY1BydX=YMe_nenkYr+bsH-3k3gObO3qav5AA5DrxMP=2Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Tue, 26 Jul 2011 16:16:42 +0530
Message-ID: <1311677203.24316.4.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 10:09 +0530, Jassi Brar wrote:
> On Tue, Jul 26, 2011 at 2:35 AM, Rob Herring <robherring2@gmail.com> wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> >
> > The pl330 needs platform data for describing peripheral connections, but
> > some platforms may only support memory to memory dma channels. In this
> > case, we can probe for how many channels there are and don't need the
> > platform data.
> >
> > As memcpy requests don't need channel private data to hold peripheral
> > info, allow private data to be NULL in this case.
> >
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Jassi Brar <jassisinghbrar@gmail.com>
> > Cc: Vinod Koul <vkoul@infradead.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> >
> > ---
> > Vinod, Can you apply this updated version instead?
> >
> > v2:
> >  - Added null ptr check
> >
> >  drivers/dma/pl330.c |   64 ++++++++++++++++++++++++++++----------------------
> >  1 files changed, 36 insertions(+), 28 deletions(-)
> 
> Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Applied thanks

-- 
~Vinod Koul
Intel Corp.

