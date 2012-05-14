Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2ENJYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:24:42 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:59153
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469Ab2ENJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:24:40 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 14 May 2012 17:43:58 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Richard Zhao <richard.zhao@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <richard.zhao@freescale.com>, <sameo@linux.intel.com>,
        <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120514094357.GF20367@S2100-06.ap.freescale.net>
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
 <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
 <20120514035137.GB20367@S2100-06.ap.freescale.net>
 <20120514080835.GB31985@opensource.wolfsonmicro.com>
 <4FB0C9D4.2060409@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB0C9D4.2060409@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 05:01:08PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> I think what the concern is we probably don't want several
> non-continuous memory blocks of misc hardwares.
> If we look into the current registers in anatop, it is really sparse.
> Several regulators are using non-continuous address and the thermals are
> also using different addresses. If the addresses are continuous then we
> don't need the mfd driver.
> 
I do not quite follow that.  The reason we need mfd driver isn't because
we do not want to both regulator and thermal drivers to map and access
the same address on their own which may have synchronization issue?

-- 
Regards,
Shawn

