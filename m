Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0KSStt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:49:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36740 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab0KSSts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fpVTZWB5ECgxZSM565uCyyVsHxbHYpyGV1YrM45wB0aE9KpvHW/n9Yi/m8ezkjqY8G
         Sl9EL+WI8Zxi+5NCs8AYcwTfRqfZHIah7damOKIcT7zM6GdPv6JRb2epo9sXg+KybzCi
         siZQD19XXonUm2S8oMyDLQKm3zAO/rlQhrwIU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011191035210.10052@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org>
	<1290109970-26752-2-git-send-email-gbean@codeaurora.org>
	<AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com>
	<alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
	<AANLkTi=p02P=-JQ9+FynFyM1yxrAh3utKTD2uzqhnLxK@mail.gmail.com>
	<alpine.DEB.2.00.1011181256470.29924@gbean-linux.qualcomm.com>
	<AANLkTiknYmWOmiFXGp6h2dT==aMuGs3BtXi82b6Vdq5i@mail.gmail.com>
	<alpine.DEB.2.00.1011191035210.10052@gbean-linux.qualcomm.com>
Date: Fri, 19 Nov 2010 10:49:47 -0800
Message-ID: <AANLkTiknSudbo_j+nqBqmds49CWyqXf0jpvz+DTYH-zg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:37 AM, Gregory Bean <gbean@codeaurora.org> wrote:
> On Thu, 18 Nov 2010, Janakiram Sistla wrote:
>
>>> Targets with the v2 block define CONFIG_MSM_V2_TLMM.
>>
>> So in that case we can name  it as gpio-tlmm.c ??
>
> No, not and have things be any clearer.
>
> All MSM chips have a TLMM block.  The older chips have
> version 1 (v1) of the TLMM block.  The newer chips have v2.
I think that we should differentiate the new gpio infrastructure with
appropriate naming that makes the diff between v1 and v2
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
