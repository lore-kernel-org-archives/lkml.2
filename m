Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2ACTUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:20:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2ACTUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:20:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111231121710.GB9842@electric-eye.fr.zoreil.com>
References: <CACPM=kXTqY1kVWrEMB-Z0Lqy6t+rXvMzixcSUy7fAz6g_ajV9g@mail.gmail.com>
	<20111230125655.GA32031@electric-eye.fr.zoreil.com>
	<CACPM=kVBxcL1_Z9zVvnEEdEgAc0rbAAbzkcocz4OYWQ2xn6VmQ@mail.gmail.com>
	<20111230180347.GA3647@electric-eye.fr.zoreil.com>
	<CACPM=kXWXUE+JcVhkz-6tGZ2YyteN9sGA80+Pnw6+LaJ-eNWBA@mail.gmail.com>
	<20111230215024.GA5513@electric-eye.fr.zoreil.com>
	<CACPM=kUxSRhDc2EqgceBRTFgBei7dh3_n7bPyoH=8aNC_uq4FA@mail.gmail.com>
	<20111230221938.GA6197@electric-eye.fr.zoreil.com>
	<CACPM=kXAr46BXAc3t8puRB37NeFy_ZEOWZa0H=DnSioagSLpxA@mail.gmail.com>
	<CACPM=kWn41S85eLgj4G+c6cN0WBgqF=6MigSwa9QBOxD1Uh64A@mail.gmail.com>
	<20111231121710.GB9842@electric-eye.fr.zoreil.com>
Date: Tue, 3 Jan 2012 20:20:48 +0100
X-Google-Sender-Auth: qlJEngbROFjLY32L9rJcoyyHfpg
Message-ID: <CACPM=kX2B6p6CSs+s-5WUbQCLa0WZW5K9Rr+hnB5VCxkEmh=8w@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/31 Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> [...]
>> Also tried connect a machine to one of the ports, and copying a large
>> file across (something that before could make it lock up within 15
>> secords) - also worked without any problems - CPU usage around 15%
>> (mostly "top" using that), so thats not bad at all.
>>
>> Is there any other testcases that I should try out?
>
> Same thing + random ethtool link management commands.
> Same thing + random cable unplug/plug.
> Same thing + pktgen facing the lan interface.
>
> Everything at the same time.

Hey,

Is there anything else I should try out?
Also, would it be possible to push these changes to mainline as
another CONFIG option (not sure if thats possible), so more people can
enable it and test it? :)

/Bjarke

> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
