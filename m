Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab1CWTS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:18:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab1CWTS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=T21TgLz7qwA9OOqXu7yd8lJDeTV33G0THv1AC2Ff6GYRqmthcWqPIVDp9PDW+nCyXs
         mvRdXf7enovBuCJagYGg==
MIME-Version: 1.0
In-Reply-To: <1300885912.6117.16.camel@m0nster>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
	<1300485423-27281-1-git-send-email-carlv@codeaurora.org>
	<1300885912.6117.16.camel@m0nster>
Date: Wed, 23 Mar 2011 12:18:52 -0700
X-Google-Sender-Auth: pwDH7GliUm1pSvEjfoWqvy2aCzM
Message-ID: <AANLkTimYqxt1q2Ca8meEYdM0yGEHWoBqdTTDU0GXC5ge@mail.gmail.com>
Subject: Re: [PATCH 09/20] video: msm: Split out MDP2.2 HW specific code.
From: Dima Zavin <dima@android.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Carl Vanderlip <carlv@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +config MSM_MDP22
>> +       bool
>> +       depends on ARCH_MSM7X00A
>> +       default y
>> +
>
> You should remove the "default y" and this should be moved to a Kconfig
> under video (shouldn't be added into mach-msm).

Additionally, please have the right MDP version directly 'select'ed by
the ARCH_XXXX definitions instead of doing the 'depends on' business.

--Dima

>
> Daniel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
