Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1CQR7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:59:09 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:54610 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab1CQR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:59:07 -0400
Message-ID: <4D824BEA.70502@wildgooses.com>
Date: Thu, 17 Mar 2011 17:59:06 +0000
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Grant Likely <grant.likely@secretlab.ca>, rpurdie@rpsys.net,
        linux-geode@lists.infradead.org, const@mimas.ru,
        linux-kernel@vger.kernel.org
Subject: Re: Feedback please: [PATCH] leds: New PCEngines Alix LED driver
 using gpio interface
References: <4D81D7FD.1040602@wildgooses.com>	<20110317084328.41831b4c@debxo>	<AANLkTikga=zrNgfsuN4=8tCfZz0n7vkk6i0xW-zj6zSD@mail.gmail.com>	<4D8243E7.7030309@wildgooses.com> <20110317105210.420e55c4@queued.net>
In-Reply-To: <20110317105210.420e55c4@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/2011 17:52, Andres Salomon wrote:
> OLPC stuff lives in arch/x86/platform/olpc; if there was more
> alix-specific stuff, I'd suggest moving it into something similar.
> However, I didn't find any.  Maybe an arch/x86/platform/geode as a
> place to collect platform drivers for the various geode-based machines
> out there (alix, soekris, etc)?  Though honestly, I'm not that
> interested in doing the work to migrate stuff over to there.


As this is my first stab at this, I think you are agreeing that the
current change is ok as a first step at least?  (I can have a go at a
larger code re-org later...)

Can I get your final opinion on what should be in the code Copyright
statement before I resubmit with the module_init change? To recap I
don't want to alienate anyone, but the code is now based on a) leds-5501
and b) a patch from someone not currently credited in the file copyright
statement?  I have stated this origin in the commit log and noted the
derivation in the code itself. What to do..?

Thanks

Ed W
