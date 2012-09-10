Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2IJSYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:24:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52548 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab2IJSYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:24:09 -0400
Message-ID: <504E3046.9080103@wwwdotorg.org>
Date: Mon, 10 Sep 2012 12:24:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 1/1] iommu/tegra: smmu: Use debugfs_create_dir for directory
References: <20120809155624.b781edae9efa7c51faf6c31c@nvidia.com><1345009652-13408-1-git-send-email-hdoyu@nvidia.com><502BCA9E.5090206@wwwdotorg.org> <20120904.095134.292349834288373260.hdoyu@nvidia.com>
In-Reply-To: <20120904.095134.292349834288373260.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 12:51 AM, Hiroshi Doyu wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 15 Aug 2012 18:13:18 +0200:
> 
>> On 08/14/2012 11:47 PM, Hiroshi Doyu wrote:
>>> The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
>>> used only for regulars" doesn't allow to use debugfs_create_file() for
>>> dir. Keep debugfs data in smmu_device instead of directory's i_private.
>>>
>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>
>> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
>>
>> Since this fixes a BUG during kernel boot, it'd be great if this could
>> be applied ASAP unless there are significant issues with it.
> 
> Joerg, any chance to get this in?

Joerg, could you please apply this patch ASAP? Currently, Tegra won't
boot in linux-next without it. Alternatively, would you like me to take
the patch through the Tegra tree? Thanks.
