Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2JOLlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:41:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17834 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JOLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:41:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 15 Oct 2012 04:41:47 -0700
Message-ID: <507BF65F.9010803@nvidia.com>
Date: Mon, 15 Oct 2012 17:11:19 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/5] regmap: add API to get irq_domain from regmap
 irq
References: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com> <1349889545-21517-5-git-send-email-ldewangan@nvidia.com> <20121015005634.GA24935@opensource.wolfsonmicro.com>
In-Reply-To: <20121015005634.GA24935@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012 06:26 AM, Mark Brown wrote:
> On Wed, Oct 10, 2012 at 10:49:04PM +0530, Laxman Dewangan wrote:
>> Add API regmap_irq_get_irq_domain() for getting the
>> irq domain from regmap irq. The irq domain created on
>> result of regmap_add_irq_chip() from driver.
> Sorry, when doing the merge down after the merge window I realised that
> I already have a patch there adding a function regmap_irq_get_domain()
> which has been sitting there for a while now, I think it was just fat
> fingers that meant it didn't make v3.7.
Thanks, then I need to create to the patch5 based on this new API.
So patch 1 to 3 can be applied directly without any new patches.


