Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0KRUjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:39:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40476 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab0KRUje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=quhhGwFYmHA7Cf/1KpfzBe+EUfokKz3NoVl1ewXSj4a1U46oZ15j2Ly/ZLIgaPJ7M/
         mBNC9etPFgPKl5i2ALJLjIz2YjacEmsde98yq9JE8r/coWnB2wSYAwG+XYL1B+iLU3oq
         lZq+Mugzs4oGFe0yo81PGygSuT/vJfUscuZM4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org>
	<1290109970-26752-2-git-send-email-gbean@codeaurora.org>
	<AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com>
	<alpine.DEB.2.00.1011181229380.26784@gbean-linux.qualcomm.com>
Date: Thu, 18 Nov 2010 12:39:32 -0800
Message-ID: <AANLkTi=p02P=-JQ9+FynFyM1yxrAh3utKTD2uzqhnLxK@mail.gmail.com>
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

On Thu, Nov 18, 2010 at 12:30 PM, Gregory Bean <gbean@codeaurora.org> wrote:
> On Thu, 18 Nov 2010, Janakiram Sistla wrote:
>
>> Can you let me know how this naming convention gpio-v2??
>>
>> Do you mean to MSM have v1 and v2 gpio hardware ??? can not we
>> have one file under mach-msm as gpio.c??
>
> The MSM8x60 is the first MSM chip to carry the second-generation, or v2,
> GPIO hardware block.  This block is not backward compatible with the
> v1 block found on older MSMs, so the two drivers cannot be elegantly merged.
so this is applicable to 8x60 and coming chip sets.I basically have a
question,How come a a new person under stand the  chipset uses gpio-v1
or gpiov2??
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
