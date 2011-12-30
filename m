Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1L3Ls7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 06:48:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54878 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1L3Lsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 06:48:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111229235312.GA27092@electric-eye.fr.zoreil.com>
References: <CACPM=kXOddA+T6vQPijR6sh8x5cMO=4baKGeKxEmMKG896Lz4g@mail.gmail.com>
	<20111229153902.GB21946@electric-eye.fr.zoreil.com>
	<20111229183902.GC21946@electric-eye.fr.zoreil.com>
	<20111229.170514.1766899380937848638.davem@davemloft.net>
	<CACPM=kV8NwYLAdODQHxYmJ21X0RmZ8KJT9szKdY2xa-DsesvQg@mail.gmail.com>
	<CACPM=kVfsXgFhKheevTS1pm7kCoezKO3M+102O=PRbXzxebxxg@mail.gmail.com>
	<20111229235312.GA27092@electric-eye.fr.zoreil.com>
Date: Fri, 30 Dec 2011 12:48:55 +0100
X-Google-Sender-Auth: hnLLvBIX7aT0C6lBYpxSYAaOSMg
Message-ID: <CACPM=kXTqY1kVWrEMB-Z0Lqy6t+rXvMzixcSUy7fAz6g_ajV9g@mail.gmail.com>
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

2011/12/30 Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> [...]
>> Would it be a problem if I try and use the patch on top of a clean
>> 3.1.6 kernel ?
>
> You will have to "cd drivers/net && patch -p5 ..." as the paths are
> different. Avoid suspend/resume/runtime PM.

Sorry for asking a probably obvious question, but whats next to get it
fixed and ready for inclusion?

/Bjarke

> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
