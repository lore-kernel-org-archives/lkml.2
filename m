Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab1ACSLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:11:11 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1517 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab1ACSLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:11:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6215"; a="68857274"
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated
 workqueues
From: Daniel Walker <dwalker@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>, linux-usb@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
In-Reply-To: <20110103170615.GB2285@redhat.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-21-git-send-email-tj@kernel.org>
	 <20110103170615.GB2285@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 10:10:45 -0800
Message-ID: <1294078245.18295.5.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 18:06 +0100, Stanislaw Gruszka wrote:
> On Mon, Jan 03, 2011 at 02:49:43PM +0100, Tejun Heo wrote:
> > With cmwq, there's no reason to use separate workqueues.  Drop
> > msmfb_info->resume_workqueue and use system_wq instead.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> I'm not the right person, CC according to MAINTAINERS

ARM/QUALCOMM MSM MACHINE SUPPORT
M:      David Brown <davidb@codeaurora.org>
M:      Daniel Walker <dwalker@codeaurora.org>
M:      Bryan Huntsman <bryanh@codeaurora.org>
L:      linux-arm-msm@vger.kernel.org
F:      arch/arm/mach-msm/
F:      drivers/video/msm/
F:      drivers/mmc/host/msm_sdcc.c
F:      drivers/mmc/host/msm_sdcc.h
F:      drivers/serial/msm_serial.h
F:      drivers/serial/msm_serial.c
T:      git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
S:      Maintained



-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

