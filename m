Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2F2CHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 22:07:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15033 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2F2CHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 22:07:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Jun 2012 19:06:57 -0700
Message-ID: <4FED0DB8.9080103@nvidia.com>
Date: Fri, 29 Jun 2012 07:36:48 +0530
From: Prashant G <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH 2/6] ARM: tegra20: Separate out clk ops and clk data
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com> <1340879846-12900-3-git-send-email-pgaikwad@nvidia.com> <4FEC965F.4060104@wwwdotorg.org>
In-Reply-To: <4FEC965F.4060104@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 11:07 PM, Stephen Warren wrote:
> On 06/28/2012 04:37 AM, Prashant Gaikwad wrote:
>> Move clock initialization data to separate file. This is
>> required for migrating to generic clock framework if static
>> initialization is used.
>>
>> TODO: Add clock suspend/resume support
> Is the suspend/resume code something that was present in the existing
> Tegra clock code? If not, I'd be tempted to just drop that TODO line
> from the patch description when applying this.
It was there for Tegra20. I am planning to add it as part of 
suspend/resume support for both Tegra30 and Tegra20.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

