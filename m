Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1AJWnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:43:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1AJWnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v4HfVlqnYNPKWxvEnrTDIR3P3qsgy/LOhx/V5xnWKSvXP7SdmIYW5chX8U33wWxCGO
         0yGpf2APhtpohccrSSAw==
MIME-Version: 1.0
In-Reply-To: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
References: <1283015148-10747-1-git-send-email-gbean@codeaurora.org>
	<1283015148-10747-4-git-send-email-gbean@codeaurora.org>
	<AANLkTikrLnGxNSJgv3KDNAQ5kvjNd8aPrOEBwftiiyrQ@mail.gmail.com>
	<1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
Date: Mon, 10 Jan 2011 14:43:37 -0800
Message-ID: <AANLkTi=0e9e1=D9m_cGuGKL+Q7aZEpncWHiLHyVmTad4@mail.gmail.com>
Subject: Re: [PATCH 4/5 v4] msm: convert 7x30 to gpiomux.
From: Dima Zavin <dmitriyz@google.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send under different title:
    [PATCH] ARM: msm: 7x30: don't force a gpiomux table for the whole arch

On Mon, Jan 10, 2011 at 9:33 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Sun, 2011-01-09 at 14:53 -0800, Dima Zavin wrote:
>> Greg,
>>
>> Just rebased on top of 2.6.37 and this patch is totally the wrong way
>> to go about this.
>>
>> I should have commented at the appropriate time, so sorry for the late reply.
>>
>> Having this  msm_gpiomux_configs be always compiled in for all msm7x30
>> devices makes this entire system completely inflexible since you have
>> to modify common code to provide board specific initialization. The
>> definition of "msm_gpiomux_configs" belongs in the board file, not in
>> gpiomux-7x30.c. I think we need to delete this new file and move the
>> definition back into board-msm7x30.c, but just use the new gpiomux
>> APIs.
>>
>> I can provide a patch if you like.
>
> I would just provide the patch .. It would be easier to understand what
> your talking about.
>
> Daniel
>
>
> --
>
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
