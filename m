Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab1JGO0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:26:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:6439 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1JGO0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:26:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,502,1312182000"; 
   d="scan'208";a="24179156"
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1317200618.1573.1765.camel@vkoul-udesk3>
	 <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	 <1317295068.1573.1780.camel@vkoul-udesk3>
	 <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	 <CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	 <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	 <CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	 <CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	 <CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	 <20111003161349.GB28287@flint.arm.linux.org.uk>
	 <CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
	 <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	 <1317966346.1573.2252.camel@vkoul-udesk3>
	 <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 19:49:37 +0530
Message-ID: <1317997177.1573.2275.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 16:57 +0530, Jassi Brar wrote:
> On 7 October 2011 11:15, Vinod Koul <vinod.koul@intel.com> wrote:
> 
> > Thru this patch Jassi gave a very good try at merging DMA_SLAVE and
> > memcpy, but more we debate this, I am still not convinced about merging
> > memcpy and DMA_SLAVE yet.
> >
> Nobody is merging memcpy and DMA_SLAVE right away.
> The api's primary purpose is to support interleave transfers.
> Possibility to merge other prepares into this is a side-effect.
For interleaved isn't that what you are trying?
> 
> > I would still argue that if we split this on same lines as current
> > mechanism, we have clean way to convey all details for both cases.
> >
> Do you mean to have separate interleaved transfer apis for Slave
> and Mem->Mem ? Please clarify.
If we can make API cleaner and well defined that way then Yes :)

-- 
~Vinod

