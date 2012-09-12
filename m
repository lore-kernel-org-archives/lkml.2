Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2ILUdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:33:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52345 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2ILUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:33:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6833"; a="235919777"
Message-ID: <5050F171.2060704@codeaurora.org>
Date: Wed, 12 Sep 2012 13:32:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 06/13] ARM: SoC: convert MSM SMP to SoC descriptor
References: <1347461906-13527-1-git-send-email-arnd@arndb.de> <1347461906-13527-7-git-send-email-arnd@arndb.de> <20120912162651.GA22904@codeaurora.org>
In-Reply-To: <20120912162651.GA22904@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/12 09:26, David Brown wrote:
> On Wed, Sep 12, 2012 at 04:58:19PM +0200, Arnd Bergmann wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Convert MSM SMP platforms to use the SoC descriptor to provide
>> their SMP and CPU hotplug operations.
>>
>> Cc: David Brown <davidb@codeaurora.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  arch/arm/mach-msm/board-msm8960.c |    3 +++
>>  arch/arm/mach-msm/board-msm8x60.c |    7 +++++++
> Stephen Boyd recently sent out a patch series that remove the non-DT
> support for these two targets, which naturally generates a bunch of
> conflicts.
>
> I'm about to send out a pull request including these changes, and
> after that, I'll rework this patch for the new board files, and give
> it a try.

It would also be nice if you used the common.h file instead of adding a
core.h. common.h is a new file in the patch series you mention.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

