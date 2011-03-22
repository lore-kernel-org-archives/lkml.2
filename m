Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1CVAIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:08:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47380 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1CVAIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:08:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6292"; a="81065311"
Message-ID: <91dc9c88fe2071229e9ffa84e5dc5659.squirrel@www.codeaurora.org>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB033D22EABA@dbde02.ent.ti.com>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
    <1300485095-26923-1-git-send-email-carlv@codeaurora.org>
    <EAF47CD23C76F840A9E7FCE10091EFAB033D22EABA@dbde02.ent.ti.com>
Date: Mon, 21 Mar 2011 17:08:13 -0700 (PDT)
Subject: RE: [PATCH 01/20] video: msm: Fix typo 'mpd'->'mdp'
From: "Carl Vanderlip" <carlv@codeaurora.org>
To: "Janorkar, Mayuresh" <mayur@ti.com>
Cc: "Carl Vanderlip" <carlv@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "David Brown" <davidb@codeaurora.org>,
        "Daniel Walker" <dwalker@fifo99.com>,
        "Bryan Huntsman" <bryanh@codeaurora.org>,
        "Brian Swetland" <swetland@google.com>,
        "Dima Zavin" <dima@android.com>,
        "Rebecca Schultz Zavin" <rebecca@android.com>,
        "Colin Cross" <ccross@android.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
>> -----Original Message-----
>> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
>> owner@vger.kernel.org] On Behalf Of Carl Vanderlip
>> Sent: Saturday, March 19, 2011 3:22 AM
>> To: Russell King; David Brown; Daniel Walker; Bryan Huntsman
>> Cc: Brian Swetland; Dima Zavin; Rebecca Schultz Zavin; Colin Cross;
>> linux-
>> fbdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-arm-
>> msm@vger.kernel.org; linux-kernel@vger.kernel.org; Carl Vanderlip
>> Subject: [PATCH 01/20] video: msm: Fix typo 'mpd'->'mdp'
>>
>> From: Brian Swetland <swetland@google.com>
>>
>> Trivial fix
>
> The Subject line states that you are only changing a typo from mpd to mdp.
> The description doesn't state anything more.
> But the patch is changing Copyright info also.
>>
>> Authors:
>> Dima Zavin <dima@android.com>
>> Rebecca Schultz Zavin <rebecca@android.com>
>> Colin Cross <ccross@android.com>
>>
>> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>

It was my intention to update the files I was changing in this patchset
with the correct copyright assignments. v2 commit text will mention this
change.

    -Carl V.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

