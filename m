Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2DYSwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:52:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56589 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab2DYSwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:52:32 -0400
Date: Wed, 25 Apr 2012 19:51:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Yong Wang <yong.y.wang@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dmaengine: Use sg_dma_address instead of sg_phys
Message-ID: <20120425185155.GB24211@n2100.arm.linux.org.uk>
References: <1335379853-10122-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335379853-10122-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 08:50:51PM +0200, Lars-Peter Clausen wrote:
> dmaengine drivers should always use sg_dma_address instead of sg_phys to get the
> addresses for the transfer from a sg element.
> 
> To quote Russel King:

Great, but please spell my name with two l's in both of your patch
descriptions.
