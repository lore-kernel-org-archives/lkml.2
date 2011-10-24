Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1JXJBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:01:18 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:11222
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab1JXJBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:01:16 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Mon, 24 Oct 2011 17:11:58 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        <broonie@opensource.wolfsonmicro.com>, <patches@linaro.org>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024091158.GB1755@S2100-06.ap.freescale.net>
References: <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
 <20111021115809.GB337@S2100-06.ap.freescale.net>
 <4EA4FF6B.2080906@ti.com>
 <20111024081706.GC8708@ponder.secretlab.ca>
 <20111024090228.GA1755@S2100-06.ap.freescale.net>
 <4EA52851.8000203@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EA52851.8000203@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:26:49PM +0530, Rajendra Nayak wrote:
> On Monday 24 October 2011 02:32 PM, Shawn Guo wrote:
> >Okay, it's wrong then since so many people say it's wrong :)  I guess
> >a quick fix would be adding one property in device tree node for
> >matching some unique field in regulator_desc, id, maybe?  Mark, any
> >suggestion?
> 
> Thats basically what the DT compatible property is for :)

But adding compatible property will get DT core create 'struct dev'
for each regulator node, while we are trying to avoid that since
regulator core has been doing this.

-- 
Regards,
Shawn

