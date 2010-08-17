Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0HQBJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 21:09:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47886 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab0HQBJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 21:09:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6076"; a="51114078"
Message-ID: <4C69E13D.3020809@codeaurora.org>
Date: Mon, 16 Aug 2010 18:09:17 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Len Brown <lenb@kernel.org>,
        Linux Power Management List <linux-pm@lists.osdl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [linux-pm] Notes from the Boston Linux Power	Management	Mini-summit
 - August 9th, 2010
References: <alpine.LFD.2.00.1008150134180.7641@localhost.localdomain> <20100816144914.GB10354@sirena.org.uk>
In-Reply-To: <20100816144914.GB10354@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Sun, Aug 15, 2010 at 01:36:33AM -0400, Len Brown wrote:
> 
>> A gap:
>>
>> On OMAP, bus control is independent of CPU frequency control,
>> so cpufreq and cpuidle don't quite fit the bill.
>>
>> Perhaps a "bus-idle" analogous to "cpu-idle" may be appropriate?
> 
> FWIW this applies to a bunch of other embedded processors too - OMAP
> isn't particularly unique here, though it's one of the furthest along in
> terms of exploting this in mainline Linux.

This capability would benefit MSM as well.  We're looking into a 
soc-specific implementation using Pat Pannuto's "pseudo" platform bus 
extensions (discussed here http://lkml.org/lkml/2010/8/10/389).  After 
we have something working, I would be curious to see if some common 
functionality could be extracted into a more generic mechanism.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
