Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab1CDULj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:11:39 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759903Ab1CDULh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vJlzWYwss7W1vDAchujfsIvdglFuv5dOHo67shP1O4D388C4ahrXxTPX8pfnkZ3+s2
         tSGD28OYsaUkmCkKb2AQ==
MIME-Version: 1.0
In-Reply-To: <4D70BE9D.4000507@stericsson.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
Date: Fri, 4 Mar 2011 12:11:32 -0800
X-Google-Sender-Auth: _bPf3bVN3b1w3CDI57kXS_DMedo
Message-ID: <AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency with cpufreq notifiers
From: Colin Cross <ccross@android.com>
To: martin persson <martin.persson@stericsson.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-arm-kernel@lists-infradead.org" 
	<linux-arm-kernel@lists-infradead.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Rob Herring <robherring2@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 2:27 AM, martin persson
<martin.persson@stericsson.com> wrote:
> We've seen no problems using this patch and have been grateful for it's
> existence. So I'm happy to put:
>
> Tested-by: martin.persson@stericsson.com
>
> /Martin
>
> On 03/04/2011 11:17 AM, Linus Walleij wrote:
>>
>> 2010/11/18 Colin Cross<ccross@android.com>:
>>
>>> The clock to the ARM TWD local timer scales with the cpu
>>> frequency. To allow the cpu frequency to change while
>>> maintaining a constant TWD frequency, pick a lower target
>>> frequency for the TWD and use the prescaler to divide down
>>> to the closest lower frequency.
>>
>> We are using this with some custom hooks for the U8500.
>>
>> Tested-by: Linus Walleij<linus.walleij@linaro.org>
>>
>> Martin Persson can probably provide an additional Tested-by
>> from ST-Ericsson if it helps.
>>
>> Colin are you merging this patch for 2.6.39 through
>> Russells tracker or pull request? It's an important patch
>> for us.
>>
>> Yours,
>> Linus Walleij
>

I never got any responses, and it conflicts with Rob Herring's patch
6434/1, although that has not been applied.  Russell, do you want this
in the patch tracker?
