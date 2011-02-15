Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1BOTf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:35:58 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16423 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1BOTfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:35:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6258"; a="74367383"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] msm: iommu: Create a Kconfig item for the IOMMU driver
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	<1297456729.4852.9.camel@m0nster>
X-Hashcash: 1:20:110215:dwalker@codeaurora.org::NU9WIOf3Jfvf8htS:0000000000000000000000000000000000000000P/Z
X-Hashcash: 1:20:110215:linux-kernel@vger.kernel.org::RDtL8SdjkkAV+3N6:0000000000000000000000000000000000E0p
X-Hashcash: 1:20:110215:linux-arm-kernel@lists.infradead.org::JxvkxL47RbypA7Rp:00000000000000000000000001tfc
X-Hashcash: 1:20:110215:stepanm@codeaurora.org::xkHiEYlORw+QvCgE:0000000000000000000000000000000000000002HwB
X-Hashcash: 1:20:110215:linux-arm-msm@vger.kernel.org::fY90uFTmWAEEXHro:000000000000000000000000000000007kUQ
Date: Tue, 15 Feb 2011 11:35:54 -0800
In-Reply-To: <1297456729.4852.9.camel@m0nster> (Daniel Walker's message of
	"Fri, 11 Feb 2011 12:38:49 -0800")
Message-ID: <8yar5b9850l.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11 2011, Daniel Walker wrote:

> On Fri, 2011-02-11 at 12:28 -0800, Stepan Moskovchenko wrote:
>> +config MSM_IOMMU
>> +       bool "MSM IOMMU Support"
>> +       depends on ARCH_MSM8X60
>> +       select IOMMU_API
>> +       default n
>> +       help
>> +         Support for the IOMMUs found on certain Qualcomm SOCs.
>> +         These IOMMUs allow virtualization of the address space used by most
>> +         cores within the multimedia subsystem.
>> +
>> +         If unsure, say N here. 
>
> I think you should just make this a hidden option, unless there is a
> good reason why any given users might want to turn this off.

In this particular case, the driver is optional, even devices that use
it will be able to work both with and without it.  It makes sense to be
able to decide whether to have it or not.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
