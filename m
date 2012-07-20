Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2GTGn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:43:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12293 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2GTGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:43:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Jul 2012 23:43:24 -0700
Message-ID: <5008FBE5.9090603@nvidia.com>
Date: Fri, 20 Jul 2012 12:04:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] dma: tegra: enable/disable dma clock
References: <1342601769-13852-1-git-send-email-ldewangan@nvidia.com>	 <1342764141.1726.199.camel@vkoul-udesk3>  <5008F4D8.9070108@nvidia.com> <1342766445.1726.246.camel@vkoul-udesk3>
In-Reply-To: <1342766445.1726.246.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012 12:10 PM, Vinod Koul wrote:
> On Fri, 2012-07-20 at 11:34 +0530, Laxman Dewangan wrote:
>> On Friday 20 July 2012 11:32 AM, Vinod Koul wrote:
>>
> for a start you can move these to .alloc_chan_resources
> and .free_chan_resources while doing a  refcount.
> Further optimization can be done by moving this to tx_submit and
> tasklet.
>
Agree. I will send the new patch.

