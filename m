Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1ILXid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:38:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38664 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab1ILXia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:38:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6467"; a="118002047"
Date: Mon, 12 Sep 2011 18:38:27 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch v3 21/36] Hexagon: Add SMP support
Message-ID: <20110912233827.GB6925@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
 <20110909010916.709728186@codeaurora.org>
 <1315752712.455.50.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315752712.455.50.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 11:51:52AM -0300, Benjamin Herrenschmidt wrote:
> And on the producer side, a spinlock for one or... that looks like wheel
> re-inventing to me :-)
> 
> In fact your bit iteration loop also re-invents find_*_bit interfaces.
> 
> Any reason why you don't simply use bitops or atomics here ?

No particular reason; just the way it turned out when I was getting things
working.  I'll get them cleaned up.


> Also what is your memory model ? ordered or weakly ordered ? Do you need
> some kind of memory barrier between setting ipi->bits and
> __vmintop_post() ?

Our model is ordered, so there's no need for a barrier there yet.


Thanks,
Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
