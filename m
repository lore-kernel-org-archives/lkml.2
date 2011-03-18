Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab1CRRw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:52:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50182 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1CRRwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=StnyVHVWaSukwCTrDGM4yyUtiwHclZyOVUlwTRaPUchDwTSH+EC7UFInpIi8+phZNe
         bKbImynXGzphhhtweYMSz5tO5re11QQ1gulv9b3WBPPFWIqGDsNgZRKIqTrVue7bFHa1
         DDYzPcEEzkRDI9kIrs7n0JKV6qhEyrOrPhAho=
MIME-Version: 1.0
In-Reply-To: <20110318142618.GA3142@gmail.com>
References: <1300436784-26543-1-git-send-email-vapier@gentoo.org> <20110318142618.GA3142@gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 18 Mar 2011 13:52:26 -0400
X-Google-Sender-Auth: V9m1tQvmNP69DnmAk1Z4Ycqsj8M
Message-ID: <AANLkTinExKgnaSMceMhMkAD8rF9RM4UM363WjgtfmZFt@mail.gmail.com>
Subject: Re: [PATCH] rtc-bfin: add missing "return 0" in new alarm func
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 10:26, Harry Wei wrote:
> On Fri, Mar 18, 2011 at 04:26:24AM -0400, Mike Frysinger wrote:
>> The new bfin_rtc_alarm_irq_enable function forgot to add a "return 0" to
>> the end leading to the build warning:
>>       drivers/rtc/rtc-bfin.c: In function 'bfin_rtc_alarm_irq_enable':
>>       drivers/rtc/rtc-bfin.c:253: warning: control reaches end of non-void function
>
>   I am sure we should give a return-value
> but whether it is '0'? Maybe it should return
> other value.
>   Can you give some explanations for yours.

read the interface.c code ... this func returns 0 on "success".  i
dont know what other possible value this could return.
-mike
