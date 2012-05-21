Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2EUDyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 23:54:23 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:9384
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab2EUDyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 23:54:22 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 21 May 2012 12:13:56 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Richard Zhao <richard.zhao@freescale.com>
CC: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>, <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120521041355.GF5810@S2100-06.ap.freescale.net>
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
 <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
 <20120514035137.GB20367@S2100-06.ap.freescale.net>
 <20120514080835.GB31985@opensource.wolfsonmicro.com>
 <4FB0C9D4.2060409@linaro.org>
 <20120514094357.GF20367@S2100-06.ap.freescale.net>
 <4FB10821.4000004@linaro.org>
 <20120514135035.GC29393@b20223-02.ap.freescale.net>
 <20120518095932.GI30755@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120518095932.GI30755@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 05:59:32PM +0800, Richard Zhao wrote:
> Guys, we need to draw conclusion.
> I think current patch keep some how compatible with multi-anatop.
> It's ok.
> 
I'm fine with that.

-- 
Regards,
Shawn

