Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2IAUef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 16:34:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59383 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2IAUee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 16:34:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120831122616.GA4083@x1.osrc.amd.com>
References: <CAH0vN5Jn1g+zekr-Nd=GizskgbcOGj8zoq+m6OvBiO6Xkw5-UQ@mail.gmail.com>
	<20120831083727.GA2903@liondog.tnic>
	<CAH0vN5J0_3B2e_dmLk1yaKfCde79egkG-s7THrKtEwzcLnmm5Q@mail.gmail.com>
	<20120831122616.GA4083@x1.osrc.amd.com>
Date: Sat, 1 Sep 2012 17:26:58 -0300
Message-ID: <CAH0vN5KS1UpxFHx0L_9btY_P0TKnNst74uBqZo+CGt4qWOdYsQ@mail.gmail.com>
Subject: Re: Get the min and max frequency of a processor
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/31 Borislav Petkov <bp@alien8.de>:
> On Fri, Aug 31, 2012 at 06:52:46AM -0300, Marcos Souza wrote:
>> Nothing is wrong with access /sys, but I thought there was another
>> way, like an API or something else.
>
> Ah, there's no API, AFAICT.
>
> Also, tools/power/cpupower/ uses sysfs too - you could reuse that
> code if you don't feel like writing it yourself. The function is
> cpufreq_get_hardware_limits()

I will take a look in the cpupower.

> Ok, technically, there is also a way to query the CPU's MSRs directly
> but this is a bit more involved than reading sysfs nodes.

My application don't need this complexity. I believe the /sys nodes
ould help me.

> HTH.
>
> --
> Regards/Gruss,
> Boris.

Thanks Borislav for showing to me all available choises to do this job!


-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
