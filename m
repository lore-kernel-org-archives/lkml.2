Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030232Ab2CUNuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:50:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:8943 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab2CUNuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:50:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79968146"
Subject: Re: [PATCH 0/2 V2] dmaengine: add context parameter to
 prep_slave_sg and prep_dma_cyclic
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        linus.walleij@stericsson.com, leoli@freescale.com, zw@zh-kernel.org,
        STEricsson_nomadik_linux@list.st.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, mchehab@infradead.org,
        ludovic.desroches@atmel.com, cjb@laptop.org, g.liakhovetski@gmx.de,
        ian@mnementh.co.uk, dwmw2@infradead.org, grant.likely@secretlab.ca,
        alan@linux.intel.com, balbi@ti.com, FlorianSchandinat@gmx.de,
        perex@perex.cz, tiwai@suse.de, viresh.kumar@st.com,
        baohua.song@csr.com, srinidhi.kasagar@stericsson.com
In-Reply-To: <1332337434.19804.5.camel@vkoul-udesk3>
References: <1331238913-25818-1-git-send-email-alexandre.bounine@idt.com>
	 <1332337434.19804.5.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 19:23:11 +0530
Message-ID: <1332337991.19804.7.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 19:13 +0530, Vinod Koul wrote:
> On Thu, 2012-03-08 at 15:35 -0500, Alexandre Bounine wrote:
> Can you rebase this series with Acks collected so that I can merge.
> The sequence fails to apply on current next, and SHA1 information in not
> enough for me to perform a merge :(
My bad, I forgot to sort the sequence before applying hence the issue.
It applied now. Getting compile tested for all dmac archs, if
compilation succeeds it will pushed. Thanks for this work 

-- 
~Vinod

