Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2BGF2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:28:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10521 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2BGF2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:28:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 06 Feb 2012 21:28:29 -0800
Message-ID: <4F30B679.4060106@nvidia.com>
Date: Mon, 06 Feb 2012 21:28:25 -0800
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com> <CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com> <4F2F6AE2.1040504@nvidia.com> <CACRpkdbtTPSoX1x4aBtNVGZ2Qex9t77D09V9JgON_jfShQdx6w@mail.gmail.com> <20120206190315.GU1426@atomide.com>
In-Reply-To: <20120206190315.GU1426@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 11:03 AM, Tony Lindgren wrote:
> * Linus Walleij <linus.walleij@linaro.org> [120206 08:58]:
>> On Mon, Feb 6, 2012 at 6:53 AM, Stephen Warren <swarren@nvidia.com> wrote:
>>
>> I will certainly finalize the pinctrl subsystem as-is, adding the
>> pin configurations states as the last major piece. If for nothing
>> else it provides some understanding of the problem space.
>>
>> I think we should keep both for the time being and consider the
>> alternative approach when patches appear. So if/when someone
>> creates a new subsystem like this, drivers can move over to it on a
>> per-driver basis. If there are zero drivers left in pinctrl it can be
>> deleted.
> 
> Yes it seems that we can easily do both. So far the only
> change needed for pinctrl drivers containing no data is that
> we should make the string names optional and structure debugfs
> around the physical register addresses instead. I'm basically
> just setting the mux register physcal address as the pin name
> for now to work around this.

I was thinking that since there was just a plain list of register
writes, there wouldn't be any concept of pins, groups, functions, etc.
at all. As such, it wouldn't really fit into pinctrl as-is; it'd need to
be either something separate, or pinctrl to change substantially more
than just allowing unnamed pins, wouldn't it?

-- 
nvpublic
