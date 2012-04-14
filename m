Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2DNPKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:10:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43541 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2DNPKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120414100601.GA11698@electric-eye.fr.zoreil.com>
References: <CACPM=kWa=UWuCMaYAtVMGJ7pzCy-PfyNRWBSuJnTZGtssU0W6g@mail.gmail.com>
	<20120410204249.GA26627@electric-eye.fr.zoreil.com>
	<CACPM=kWsU8QZOHqwEThTQCuSSvaTDoxO1d17EyoW=+kx8QG3vw@mail.gmail.com>
	<20120410225534.GA28480@electric-eye.fr.zoreil.com>
	<CACPM=kXGyxgfwzMxAhx-jUL1hYMAqWc7=9gfYcgV=xebAQ=+Og@mail.gmail.com>
	<20120414100601.GA11698@electric-eye.fr.zoreil.com>
Date: Sat, 14 Apr 2012 17:10:51 +0200
X-Google-Sender-Auth: znvGjFlJxBuveKYkVXlU59W0SsE
Message-ID: <CACPM=kUskdtJt6FxT5xkXfObFj-CEU6799hX6iQ5dZLZw6M1=w@mail.gmail.com>
Subject: Re: via-rhine: Problem with lost link after a while
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.com>,
        Andreas Mohr <andi@lisas.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14. apr. 2012 12.06 skrev Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> [...]
>> I've been testing v3.4-rc2 with this patch applied for the past few
>> days, with alot of trafic across, both incoming and outgoing, with VPN
>> which is normally what can trigger problems, and it seems rock solid
>> :o)
>
> Thanks.
>
>> Do you need me to do any specific testing of this patch?
>
> See below.
>
> Changes of behavior should be reported for this patch over plain 3.4-rc2 or
> current 3.3-stable as both include Andreas's fix.
>
> Otherwise it can not be labelled it as a fix : it does not go into 3.4-rc
> nor 3.3-stable but proceeds through net-next where it will land into
> 3.5-rc then -stable.
>
> One can not exercize the Tx xmit vs napi Tx completion race part of the
> patch with a single core. Afaiui non-Soekris users are needed here.
>
> Even if you don't experience change of behavior over 3.4-rc or 3.3-stable,
> some longterm use of this driver would be welcome. It may end as an effort
> for 3.5-rc though.

Okay, I'll keep staying up to date with 3.4-rcX and report if anything breaks.
Going for v3.5-rc should be fine AFAICS :-)

/Bjarke

> --
> Ueimor
>
> Will code drivers for food.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
