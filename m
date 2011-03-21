Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab1CURX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:23:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1CURX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:23:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6291"; a="81191080"
Message-ID: <4D8789AA.8050803@codeaurora.org>
Date: Mon, 21 Mar 2011 10:23:54 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Janorkar, Mayuresh" <mayur@ti.com>
CC: Carl Vanderlip <carlv@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/20] video: msm: Refactor mdp_regs
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org> <1300485404-27241-1-git-send-email-carlv@codeaurora.org> <EAF47CD23C76F840A9E7FCE10091EFAB033D22EB6E@dbde02.ent.ti.com>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB033D22EB6E@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2011 10:17 PM, Janorkar, Mayuresh wrote:

...

>> diff --git a/drivers/video/msm/mdp_ppp.h b/drivers/video/msm/mdp_ppp.h
>> new file mode 100644
>> index 0000000..ef3b125
>> --- /dev/null
>> +++ b/drivers/video/msm/mdp_ppp.h
>> @@ -0,0 +1,50 @@
>> +/* drivers/video/msm/mdp_ppp.h
>> + *
>> + * Copyright (C) 2009 Google Incorporated
> 
> If you want correct copyright info (to 2009-2011) here.

Carl is submitting a change made by Google in 2009.  I believe having
2009 as the only copyright year is correct.  Carl/Brian, please correct
me here if the date of the change was more than 2009.  Thanks.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
