Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab1ANTR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:17:57 -0500
Received: from smtp-out.google.com ([74.125.121.67]:47263 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1ANTRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:17:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OYZe1zUvjq1F2O8T1y9aYJRJ8juX+uRC59I0gSH9xr8yrvYmO1L/9kAIQ36r29+ai/
         osUAoz/4zS5ndYlBU1HQ==
MIME-Version: 1.0
In-Reply-To: <8yalj2nfj11.fsf@huya.qualcomm.com>
References: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
	<1294686030-9817-1-git-send-email-dima@android.com>
	<8yalj2nfj11.fsf@huya.qualcomm.com>
Date: Fri, 14 Jan 2011 11:17:51 -0800
X-Google-Sender-Auth: 4sqXpejTBgXlEGTFQXnA_x7-umE
Message-ID: <AANLkTi=YxOMwF44AJcARunZAEo+iU-1z4fpD35iqUnvR@mail.gmail.com>
Subject: Re: [PATCH] ARM: msm: 7x30: don't force a gpiomux table for the whole arch
From: Dima Zavin <dima@android.com>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

--Dima

On Fri, Jan 14, 2011 at 10:16 AM, David Brown <davidb@codeaurora.org> wrote:
> On Mon, Jan 10 2011, Dima Zavin wrote:
>
>> This is completely board specific and therefore must be provided
>> on a per-board basis.
>>
>> Change-Id: I96f922ad9bb9cbce7874c5ae6ac0d7479b7a2124
>> Signed-off-by: Dima Zavin <dima@android.com>
>
> I'll pull this into msm-next once rc8-rc1 comes out.
>
> I'll take out the Change-Id line, though.
>
> David
>
