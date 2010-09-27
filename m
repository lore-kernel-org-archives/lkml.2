Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab0I0TmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:42:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48860 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424Ab0I0TmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FmvmEIzgDZWKQkMYic4SGCUv6KpaBfuEApa4HxQCNU0WBR4M92uqjX76uiu4g85vaP
         gtSMqS5qx60A17NqpxlhAWLAiIs+BrElEi2y9Badi+zBF9Ve5WZi1vXs2loKQNziRday
         mPJu8A5AuiuR6eWTJwe1GPEK7HLhxX4XUfJfA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=gsvcWJak88NOfMjTumtLcdcU6-RUE+obWcacz@mail.gmail.com>
References: <1285529740-28232-1-git-send-email-notasas@gmail.com>
	<AANLkTinkxokX9BGtxysYOr19xbZR4S8oPRYUAyneutzc@mail.gmail.com>
	<AANLkTinh+JTwyE4E33QXdnZ8obYA8S0SU71i3kGi=wRT@mail.gmail.com>
	<AANLkTik0LOQN8kOPjv_VohhO5To6pZDS=M0mw=q0whPp@mail.gmail.com>
	<AANLkTi=xS_=QytU0Yrh5EEiiL6GyekcO+DezjT-Zpj-7@mail.gmail.com>
	<AANLkTi=gsvcWJak88NOfMjTumtLcdcU6-RUE+obWcacz@mail.gmail.com>
Date: Mon, 27 Sep 2010 22:42:21 +0300
Message-ID: <AANLkTikWJ-n708ou_BkVchCvk025GVo-Ljq+CHe4T5vT@mail.gmail.com>
Subject: Re: [PATCH v3] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: Arun Murthy <arunrmurthy.83@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> How do I get notified if battery voltage is low and needs charging
>>> from user space?
>>
>> Either additional monitoring chip notifies you (if you are lucky and
>> have one), or wait for update of this driver :) There are efforts to
>> merge MADC driver [1], but it may take some time.
> But using MADC, I can get the battery voltage and by means of
> monitoring battery voltage we can get to know low battery
> notification.

True, but let's wait for MADC driver to be merged for that first.

>>
>> [1] http://marc.info/?t=128461535700002&r=1&w=2
>>
> Thanks and Regards,
> Arun R Murthy
> --------------------
>
