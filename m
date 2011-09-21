Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1IUUWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:22:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4759 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1IUUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:22:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6476"; a="120489026"
Date: Wed, 21 Sep 2011 13:22:02 -0700
From: David Brown <davidb@codeaurora.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Geoff Levand <geoff@infradead.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Anatolij Gustschin <agust@denx.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jiri Kosina <jkosina@suse.cz>, Archit Taneja <archit@ti.com>,
        linux-fbdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 49/57] video: irq: Remove IRQF_DISABLED
Message-ID: <20110921202202.GB2321@huya.qualcomm.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-50-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316597339-29861-50-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:28:50PM +0800, Yong Zhang wrote:
> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  drivers/video/msm/mddi.c                  |    2 +-
>  drivers/video/msm/mdp.c                   |    2 +-

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
