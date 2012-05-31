Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2EaNIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:08:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33796 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab2EaNIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:08:07 -0400
Message-ID: <4FC76D29.8070802@ti.com>
Date: Thu, 31 May 2012 15:07:53 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com> <4FC5DFCF.1020606@codeaurora.org> <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com> <20120531081841.GG5377@arwen.pp.htv.fi> <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com> <20120531085432.GK5377@arwen.pp.htv.fi> <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com> <4FC768F8.4050406@ti.com> <20120531130456.GB15786@sirena.org.uk>
In-Reply-To: <20120531130456.GB15786@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/2012 3:04 PM, Mark Brown wrote:
> On Thu, May 31, 2012 at 02:50:00PM +0200, Cousson, Benoit wrote:
>
>> Now the question is should we extend the Linux device structure to
>> handle such HW IP, or should we extend the clock definition to
>> handle this kind of extended clock node.
>
>> It looks to me that this kind of function does belong to the device
>> more than to the clock node.
>
> This is looking a lot like what power domains do to me...

Do you mean the reset part?


