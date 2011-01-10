Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1AJReA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:34:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37195 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1AJRd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:33:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6222"; a="69920722"
Subject: Re: [PATCH 4/5 v4] msm: convert 7x30 to gpiomux.
From: Daniel Walker <dwalker@codeaurora.org>
To: Dima Zavin <dmitriyz@google.com>
Cc: Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikrLnGxNSJgv3KDNAQ5kvjNd8aPrOEBwftiiyrQ@mail.gmail.com>
References: <1283015148-10747-1-git-send-email-gbean@codeaurora.org>
	 <1283015148-10747-4-git-send-email-gbean@codeaurora.org>
	 <AANLkTikrLnGxNSJgv3KDNAQ5kvjNd8aPrOEBwftiiyrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 09:33:30 -0800
Message-ID: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 14:53 -0800, Dima Zavin wrote:
> Greg,
> 
> Just rebased on top of 2.6.37 and this patch is totally the wrong way
> to go about this.
> 
> I should have commented at the appropriate time, so sorry for the late reply.
> 
> Having this  msm_gpiomux_configs be always compiled in for all msm7x30
> devices makes this entire system completely inflexible since you have
> to modify common code to provide board specific initialization. The
> definition of "msm_gpiomux_configs" belongs in the board file, not in
> gpiomux-7x30.c. I think we need to delete this new file and move the
> definition back into board-msm7x30.c, but just use the new gpiomux
> APIs.
> 
> I can provide a patch if you like.

I would just provide the patch .. It would be easier to understand what
your talking about.

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

