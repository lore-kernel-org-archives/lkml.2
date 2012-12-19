Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2LSKS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:18:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49163 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2LSKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:18:18 -0500
Message-ID: <50D19463.5010605@ti.com>
Date: Wed, 19 Dec 2012 11:18:11 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, Luciano Coelho <coelho@ti.com>,
        <svenkatr@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <lrg@ti.com>,
        <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
References: <1352968293.10872.51.camel@cumari.coelho.fi> <20121218095450.GB27751@arwen.pp.htv.fi> <20121219094552.GN4985@opensource.wolfsonmicro.com> <50D19040.5090404@ti.com> <20121219100909.GO4985@opensource.wolfsonmicro.com>
In-Reply-To: <20121219100909.GO4985@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 11:09 AM, Mark Brown wrote:
> On Wed, Dec 19, 2012 at 11:00:32AM +0100, Peter Ujfalusi wrote:
> 
>> I don't know the state of the common clock framework for OMAPs. Is it already
>> up in 3.7? Or going for 3.8? 3.9? 3.10?...
>> We need CCF to resolve this. I can cook up the clock driver for the 32k clock
>> from twl, but in order to use it we need CCF on OMAP.
> 
> Well, we at least ought to make sure it doesn't appear in the regulator
> DT bindings even if it's handled via some OMAP magic - that was the key
> point here.

Sure. It must be a clock driver. I already have similar driver (for McPDM fclk
clock) for twl6040.
Let me check linux-next, if CCF is there for OMAP I can send the 32k clock
driver soon (after writing it and testing it). It is going to be for 3.9 but
we can roll it with us I think locally to resolv issues.

-- 
Péter
