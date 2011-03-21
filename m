Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1CUR23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:28:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38887 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1CUR2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nBjgsJ2uQDEOSTq0iVp65ybtpzX+QjUzych+JGInXjW4kfYaTyEC9Bb6+QqzKZXh9X
         53yucG0Pxbm138+eCdtg==
MIME-Version: 1.0
In-Reply-To: <4D8789AA.8050803@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
	<1300485404-27241-1-git-send-email-carlv@codeaurora.org>
	<EAF47CD23C76F840A9E7FCE10091EFAB033D22EB6E@dbde02.ent.ti.com>
	<4D8789AA.8050803@codeaurora.org>
Date: Mon, 21 Mar 2011 10:28:22 -0700
Message-ID: <AANLkTinB+svr3GtdsTY953moPXrMGdQGuF9RMZ=fFSJW@mail.gmail.com>
Subject: Re: [PATCH 08/20] video: msm: Refactor mdp_regs
From: Brian Swetland <swetland@google.com>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: "Janorkar, Mayuresh" <mayur@ti.com>, Carl Vanderlip <carlv@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 10:23 AM, Bryan Huntsman <bryanh@codeaurora.org> wrote:
> On 03/20/2011 10:17 PM, Janorkar, Mayuresh wrote:
>>> diff --git a/drivers/video/msm/mdp_ppp.h b/drivers/video/msm/mdp_ppp.h
>>> new file mode 100644
>>> index 0000000..ef3b125
>>> --- /dev/null
>>> +++ b/drivers/video/msm/mdp_ppp.h
>>> @@ -0,0 +1,50 @@
>>> +/* drivers/video/msm/mdp_ppp.h
>>> + *
>>> + * Copyright (C) 2009 Google Incorporated
>>
>> If you want correct copyright info (to 2009-2011) here.
>
> Carl is submitting a change made by Google in 2009.  I believe having
> 2009 as the only copyright year is correct.  Carl/Brian, please correct
> me here if the date of the change was more than 2009.  Thanks.

Google is fine with leaving our copyright line as originally authored.
 No need to modify it.

Thanks,

Brian
