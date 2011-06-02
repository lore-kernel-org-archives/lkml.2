Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1FBRXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:23:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18439 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1FBRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:23:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6365"; a="94998760"
Message-ID: <f2e8134b42bb8cb6be806f21ca547f7f.squirrel@www.codeaurora.org>
In-Reply-To: <8yay61lxlnz.fsf@huya.qualcomm.com>
References: <cover.1306950701.git.joe@perches.com>
    <326591b5bd7f016a40a325fa0a532bfab47218d6.1306950701.git.joe@perches.com>
    <8yay61lxlnz.fsf@huya.qualcomm.com>
Date: Thu, 2 Jun 2011 10:23:15 -0700 (PDT)
Subject: Re: [PATCH 1/6] MAINTAINERS: Update MSM pattern
From: "Carl Vanderlip" <carlv@codeaurora.org>
To: "David Brown" <davidb@codeaurora.org>
Cc: "Joe Perches" <joe@perches.com>, carlv@codeaurora.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Daniel Walker" <dwalker@fifo99.com>,
        "Bryan Huntsman" <bryanh@codeaurora.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 01 2011, Joe Perches wrote:
>
>> Video MSM is still in staging.
>
> It also appears to be in drivers/video/msm
>
> Carl, do we need the staging driver any more?
>
> I don't have any problem removing the drivers/platform/msm line, since
> that now appears to have been an ill-formed idea, but I'd rather just
> get rid of the staging video driver.
>
> David
>

The staging video driver can be removed. While the current driver is
moving along the same dev path as the staging driver originally did, I
don't believe it is a goal to converge to the staging driver in its
current form.

 -Carl V.

>> cc: David Brown <davidb@codeaurora.org>
>> cc: Daniel Walker <dwalker@fifo99.com>
>> cc: Bryan Huntsman <bryanh@codeaurora.org>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  MAINTAINERS |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 29801f7..ae06910 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -926,7 +926,7 @@ F:	drivers/mmc/host/msm_sdcc.c
>>  F:	drivers/mmc/host/msm_sdcc.h
>>  F:	drivers/tty/serial/msm_serial.h
>>  F:	drivers/tty/serial/msm_serial.c
>> -F:	drivers/platform/msm/
>> +F:	drivers/staging/msm/
>>  F:	drivers/*/pm8???-*
>>  F:	include/linux/mfd/pm8xxx/
>>  T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

