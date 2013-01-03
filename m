Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3ACGLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:11:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4078 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3ACGLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:11:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 02 Jan 2013 22:11:14 -0800
Message-ID: <50E520FC.4070805@nvidia.com>
Date: Thu, 3 Jan 2013 11:41:08 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 05/11] ARM: dt: tegra30: Add device node for APB MISC
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com> <1356619644-18565-6-git-send-email-pgaikwad@nvidia.com> <50E4AE19.1060503@wwwdotorg.org>
In-Reply-To: <50E4AE19.1060503@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013 03:30 AM, Stephen Warren wrote:
> On 12/27/2012 07:47 AM, Prashant Gaikwad wrote:
>> APB misc contains multiple registers required by different modules
>> such as CAR.
> I don't see a DT binding document that describes what
> nvidia,tegra30-apbmisc means. Also, the register range for this new node
> overlaps that for the pinmux node, so they can't both "request" their
> register region. You may need multiple entries in the apbmisc reg
> property to avoid this.

apbmisc reg for Tegra30 can be divided into following entries:

strap registers
jtag configuration registers
pull_up/pull_down control registers
vclk control registers
tvdac registers
chip id revision registers
pad control registers

This list is not same for Tegra20 and Tegra30.

OR

another way is to add chip id revision register region to CAR node as 
done for pinmux node and remove apb misc node.

What is preferred?
