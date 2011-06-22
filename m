Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab1FVCsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:48:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53665 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1FVCsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TmFVQ/qqpdbwAX+Awr2dxhGm9/An4XdA+aKF9Zg+r8cwR+jwmlpXZLOFRAx54xXGAl
         X9GvvTWxgrx72oOx4irqSIEhojdpgwioqYe8+KLwL1s40vVTTltLQQSOFSf0wQl9rrsT
         NNW1RSKI1cGtKPrVuBCMsxJGnx6j/u4DhfU5s=
MIME-Version: 1.0
In-Reply-To: <4E00853A.7010003@linaro.org>
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
	<1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
	<1308622033-2521-2-git-send-email-myungjoo.ham@samsung.com>
	<4E002D18.2080401@linaro.org>
	<20110621111010.GH22177@opensource.wolfsonmicro.com>
	<4E00853A.7010003@linaro.org>
Date: Wed, 22 Jun 2011 11:37:43 +0900
Message-ID: <BANLkTikKnPuFXt4zL4ctVmwn4KYkWAG3sQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] Exynos4 NURI: configure regulators and PMIC
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, dg77.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 8:49 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> On Tuesday 21 June 2011 04:40 PM, Mark Brown wrote:
>>
>> On Tue, Jun 21, 2011 at 11:03:12AM +0530, Tushar Behera wrote:
>>
>>> Will it be possible to move PMIC specific defines to a common file
>>> and make appropriate calls in the board-specific file?
>>
>>> In that way, we can re-use this PMIC code on some other boards (e.g.
>>> Insignal low-cost board Origen featuring Exynos4210 also features
>>> MAX8997).
>>
>> If the board is similar enough in design to be sharing the PMIC code
>> that sounds like it should be sharing a lot more of the board setup
>> code.
>
> Origen board details can be found at http://www.origenboard.org/
>
> Under 'Documents' section, there are some schematics for the board.
>
> As for other peripherals, I am not sure how much similar this is w.r.t. NURI
> (I don't have NURI board schematics).

Well, I cannot find enough information to match PMIC device data from
the schematics in that 'Documents' section. It appears that they
provide every information but the PMIC-related.

>
> --
> Tushar Behera
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
