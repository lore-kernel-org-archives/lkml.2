Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2I0JyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:54:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:40706 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab2I0JyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="149767335"
Subject: Re: [PATCH 3/3] DMA: PL330: Balance module remove function with
 probe
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, boojin.kim@samsung.com,
        patches@linaro.org, kgene.kim@samsung.com
In-Reply-To: <CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	 <1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	 <CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	 <CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 15:18:12 +0530
Message-ID: <1348739292.1648.15.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 12:11 +0530, Inderpal Singh wrote:
> If we fail pl330_remove while some client is queued, the force unload
> will fail and the
> force unload will lose its purpose.
> How about conditionally DMA_TERMINATE_ALL and free resources like
> below ? 
Why would you want to remove the driver when it is doing something
useful? You have to ensure driver is not doing anything.

What is point here?

-- 
~Vinod

