Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2K1Ow6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:52:58 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:54157
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233Ab2K1Owz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:52:55 -0500
X-Greylist: delayed 45971 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 09:52:55 EST
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1de0h1202h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 28 Nov 2012 23:17:44 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 6/6 v6] cpufreq, highbank: add support for highbank
 cpufreq
Message-ID: <20121128151741.GC28170@S2100-06.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354046672-7392-7-git-send-email-mark.langsdorf@calxeda.com>
 <20121128023240.GA28170@S2100-06.ap.freescale.net>
 <50B60E9C.9000405@calxeda.com>
 <20121128145759.GB28170@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121128145759.GB28170@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:58:02PM +0800, Shawn Guo wrote:
> On Wed, Nov 28, 2012 at 07:16:12AM -0600, Mark Langsdorf wrote:
> > I'd
> > have to move most of the logic of hb_set_target() into
> > clk_highbank.c:clk_pll_set_rate() and then add extra logic for when
> > cpufreq is not enabled/loaded.
> 
> You only need to move hb_voltage_change() into cpu clock's .set_rate()
> hook with no need of checking if cpufreq is enabled or not.
> 
Need to also check whether frequency or voltage should be changed first
in .set_rate() though.

Shawn

