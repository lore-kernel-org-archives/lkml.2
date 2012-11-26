Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2KZTKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:10:25 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41638 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2KZTKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:10:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6908"; a="9802025"
Date: Mon, 26 Nov 2012 11:10:22 -0800
From: David Brown <davidb@codeaurora.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Kenneth Heitke <kheitke@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 01/24] MAINTAINERS: remove drivers/platform/msm/
Message-ID: <20121126191022.GD12719@codeaurora.org>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
 <1353716808-16375-2-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353716808-16375-2-git-send-email-cesarb@cesarb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 10:26:25PM -0200, Cesar Eduardo Barros wrote:
> Added by commit 8a5700c (add drivers/platform/msm to MSM subsystem) in
> 2011, but I could not find any trace of that directory being ever added
> to the repository.
> 
> Cc: Kenneth Heitke <kheitke@codeaurora.org>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: linux-arm-msm@vger.kernel.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 1 -

The directory was proposed at one point as a location for platform
data.  The ARM community has since come up with different ways of
doing this.  So, it's fine to remove this.

Acked-by: David Brown <davidb@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
