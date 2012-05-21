Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2EUJjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:39:55 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:5596
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab2EUJjw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:39:52 -0400
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h93fhd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 21 May 2012 17:39:39 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: <sameo@linux.intel.com>, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
CC: Shawn Guo <shawn.guo@freescale.com>, <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120521093937.GM30755@b20223-02.ap.freescale.net>
References: <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
 <20120514035137.GB20367@S2100-06.ap.freescale.net>
 <20120514080835.GB31985@opensource.wolfsonmicro.com>
 <4FB0C9D4.2060409@linaro.org>
 <20120514094357.GF20367@S2100-06.ap.freescale.net>
 <4FB10821.4000004@linaro.org>
 <20120514135035.GC29393@b20223-02.ap.freescale.net>
 <20120518095932.GI30755@b20223-02.ap.freescale.net>
 <20120521041355.GF5810@S2100-06.ap.freescale.net>
 <4FBA0A9A.8040901@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4FBA0A9A.8040901@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 05:27:54PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> (2012年05月21日 12:13), Shawn Guo wrote:
> > On Fri, May 18, 2012 at 05:59:32PM +0800, Richard Zhao wrote:
> >> Guys, we need to draw conclusion.
> >> I think current patch keep some how compatible with multi-anatop.
> >> It's ok.
> >>
> > I'm fine with that.
> > 
> Yes. It is good for me.
> 
So, Sameo, could you pick the patch.

Thanks
Richard

