Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1JULrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:47:40 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:1997
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285Ab1JULri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:47:38 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Fri, 21 Oct 2011 19:58:10 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111021115809.GB337@S2100-06.ap.freescale.net>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111018132032.GD30703@S2100-06.ap.freescale.net>
 <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EA13053.7080306@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:11:55PM +0530, Rajendra Nayak wrote:
[...]
> >+       /* find device_node and attach it */
> >+       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
> 
> so would this do a complete dt search for every regulator?

Yes, with the first param being NULL, tthe entire device tree will be
searched.

> we would also need the driver names and dt names to match for this to
> work, right?
> 
Driver name does not matter.  The key for this search to work is having
regulator's name (regulator_desc->name) match device tree node's name,
case ignored.

> The approach otherwise looks fine to me and should work for both cases
> of one device per regulator and one device for all regulators.
> 

-- 
Regards,
Shawn

