Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1ELJBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:01:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:20731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1ELJBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:01:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,357,1301900400"; 
   d="scan'208";a="746134482"
Subject: Re: [PATCH] dmaengine: at_hdmac: pause: no need to wait for FIFO
 empty
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1304957497-22814-1-git-send-email-nicolas.ferre@atmel.com>
References: <be7d19459501aaa604aebe91daa9e9e59bb41c86.1304704588.git.nicolas.ferre@atmel.com>
	 <1304957497-22814-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 13:58:56 +0530
Message-ID: <1305188936.28926.66.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 18:11 +0200, Nicolas Ferre wrote:
> The addition of the pause feature to atc_control an active wait was introduced
> to check the FIFO empty event. This event was not always happening and
> a timout contition was needed.
> But, in some cases, this event depend on the peripheral connected to the
> channel that is paused: FIFO becomes empty if the peripheral consumes data.
> The timeout is pretty difficult to evaluate. Moreover, this check is not
> needed.
> In conclusion, it seems sensible to entirely remove the checking of
> "FIFO empty" status when pausing.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Vinod,
> 
> This additional patch goes on top of your current "next" branch. It is a
> removing of some code added to the pause/resume patch sent earlier and can be
> folded into this one if you want to.
> 
Applied with edit in commit msg, Thanks

-- 
~Vinod

