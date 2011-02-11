Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab1BKWhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:37:20 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11458 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab1BKWhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:37:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="73911614"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple targets
In-Reply-To: <1297462350.4852.31.camel@m0nster> (Daniel Walker's message of
	"Fri, 11 Feb 2011 14:12:30 -0800")
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	<1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	<1297462350.4852.31.camel@m0nster>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110211:dwalker@codeaurora.org::W5SA5If68O/avqrj:0000000000000000000000000000000000000004Aux
X-Hashcash: 1:20:110211:linux-arm-kernel@lists.infradead.org::2nsnGDwOTswE7F67:00000000000000000000000004zeV
X-Hashcash: 1:20:110211:stepanm@codeaurora.org::fdqngf4ijzxSQ5Ov:00000000000000000000000000000000000000043Q/
X-Hashcash: 1:20:110211:linux-arm-msm@vger.kernel.org::4INRALDDAetAK3TI:000000000000000000000000000000004yDD
X-Hashcash: 1:20:110211:linux-kernel@vger.kernel.org::6GAwEynJZ+Im6HGs:000000000000000000000000000000000PWOC
Date: Fri, 11 Feb 2011 14:37:18 -0800
Message-ID: <8ya7hd6kxk1.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11 2011, Daniel Walker wrote:

> On Fri, 2011-02-11 at 12:28 -0800, Stepan Moskovchenko wrote:
>> Make the IOMMU platform data target-independent in
>> preparation for adding MSM8960 IOMMU support. The IOMMU
>> configuration on MSM8x60 and MSM8960 is identical and the
>> same platform data can be used for both.
>> 
>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>> ---
>>  arch/arm/mach-msm/Makefile                         |    4 +-
>>  .../{devices-msm8x60-iommu.c => devices-iommu.c}   |   54 +++++++++----------
>>  arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |   36 -------------
>>  3 files changed, 28 insertions(+), 66 deletions(-)
>>  rename arch/arm/mach-msm/{devices-msm8x60-iommu.c => devices-iommu.c} (93%)
>
> If it's like what you and David are suggesting I think you would need a
> SoC designation in the filename ..

It is functionality that will be shared across multiple socs.  Putting
the name of a specific soc would just be misleading.  Currently, it's
our only iommu.  Support for another family that uses a different iommu
could perhaps call it iommu2.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
