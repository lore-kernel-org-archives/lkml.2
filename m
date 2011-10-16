Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1JPMYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 08:24:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:14034 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1JPMYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 08:24:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,353,1315206000"; 
   d="scan'208";a="63044962"
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
In-Reply-To: <CAJe_ZheR678_W28cQeqRbRDjJobAVWAN403v9M5mQ+KYbXr3RA@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	 <1318605396.1546.424.camel@vkoul-udesk3>
	 <CAJe_ZheR678_W28cQeqRbRDjJobAVWAN403v9M5mQ+KYbXr3RA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 17:46:26 +0530
Message-ID: <1318767386.23438.93.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 16:46 +0530, Jassi Brar wrote:
> > IMO this looks decent now, we can take this for merge if we don't
> have
> > any other issues.
> > Ideally would be great if we also need to see the usage for this
> > API .... Barry?. I am okay to host this up on a branch meanwhile.
> >
> > Just a minor nitpick, I would have really like dmaxfer_template to be
> > named dma_interleaved_template. I think we are still quite far from
> > generic transfer template. Jassi if you agree I can fix that up while
> > applying, no need to revise for nitpick :)
> >
> There is need to provide cyclic functionality but we seem to disagree on
> implementation. So you might as well take this patch and provide
> cyclic feature, the way you want, as a patch on top of this.
> I am ok with dmaxfer_template renaming. 
Thanks, I have changed it and pushed to branch interleaved_dma.

Once Barry sends his drivers using this API, will merge 

-- 
~Vinod

