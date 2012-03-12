Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2CLUOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:14:32 -0400
Received: from fifo99.com ([67.223.236.141]:35047 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab2CLUO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:14:29 -0400
Date: Mon, 12 Mar 2012 13:14:21 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
Message-ID: <20120312201421.GA3459@fifo99.com>
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 04:02:44PM +0530, Ravi Kumar V wrote:
> Add DMAEngine based driver using the old MSM DMA APIs internally.

What do you mean by this?

> The benefit of this approach is that not all the drivers
> have to get converted to DMAEngine APIs simultaneosly while
> both the drivers can stay enabled in the kernel. The client
> drivers using the old MSM APIs directly can now convert to
> DMAEngine one by one.

Which drivers?

Daniel
