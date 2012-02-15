Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2BOHMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:12:54 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25281 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2BOHMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:12:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6620"; a="160978559"
Message-ID: <7d1016122f840cf62f669f06355b8605.squirrel@www.codeaurora.org>
In-Reply-To: <CAKYAXd9pXfL1S_KSLoF48AKNtxj9-svdDdXp=_DYZAmBvFFddg@mail.gmail.com>
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
    <CAKYAXd9pXfL1S_KSLoF48AKNtxj9-svdDdXp=_DYZAmBvFFddg@mail.gmail.com>
Date: Tue, 14 Feb 2012 23:12:51 -0800 (PST)
Subject: Re: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Namjae Jeon" <linkinjeon@gmail.com>
Cc: "Seungwon Jeon" <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        "Chris Ball" <cjb@laptop.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012/1/26 Seungwon Jeon <tgih.jun@samsung.com>:
>> This patch supports packed command of eMMC4.5 device.
>> Several reads(or writes) can be grouped in packed command
>> and all data of the individual commands can be sent in a
>> single transfer on the bus.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
>
> Looks good to me also.
> Thanks.
Hi,

I'm running performance tests on this patch and would appreciate if you
could wait with its approval until I'll have final conclusions (next
week).
Thanks,
Maya
>> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


