Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab1FVCbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:31:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41881 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab1FVCbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=js9jhhGC1A8kMwNgX4kjFCkezvTeR49h0N5Ph9iqo3E9SFvZ3vY8LThLsrClRXxLIg
         sApmwqQCtOkRCmbd5Z6V1aNrVetEA+fl7TwRRMVxZ8a3vu8YJahaMjFcrQjN3vRpy7bS
         8Jse+bfRoZkPnKfNfQnWZNaFoenB16P4+7XGw=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <4E002D18.2080401@linaro.org>
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
	<1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
	<1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com>
	<4E002D18.2080401@linaro.org>
Date: Wed, 22 Jun 2011 11:31:35 +0900
X-Google-Sender-Auth: wS7BHQWHdqV775CSAPdfn8f8oLM
Message-ID: <BANLkTi=pv=y+1XC5bYEHgL1sy48JPztiOg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] Exynos4 NURI: configure regulators and PMIC
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, dg77.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 2:33 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> On Tuesday 21 June 2011 07:37 AM, MyungJoo Ham wrote:
>>
>> Signed-off-by: MyungJoo Ham<myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>
>> --
>> Changes from v1. Thanks so much for your valuable comments, Mark.
>> - Removed unnecessary initialization data
>> - Add __initdata where necessary
>> - Corrected a regulator name for ADC
>> ---
>>  arch/arm/mach-exynos4/mach-nuri.c |  622
>> ++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 621 insertions(+), 1 deletions(-)
>>
> Will it be possible to move PMIC specific defines to a common file and make
> appropriate calls in the board-specific file?
>
> In that way, we can re-use this PMIC code on some other boards (e.g.
> Insignal low-cost board Origen featuring Exynos4210 also features MAX8997).
>

Yes, we have tried creating PMIC defines at a seperated file in our
local repositories (still doing so in those repositories).
However, that ended up creating multiple PMIC defines (one PMIC define
file for each board); the connections between LDO# and devices are
different.

>
> --
> Tushar Behera
>


-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
