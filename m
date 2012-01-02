Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2ABIoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:44:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42939 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2ABIok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:44:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120101224909.GA18144@electric-eye.fr.zoreil.com>
References: <1325452525-23476-1-git-send-email-gurligebis@gentoo.org>
	<20120101224909.GA18144@electric-eye.fr.zoreil.com>
Date: Mon, 2 Jan 2012 09:44:39 +0100
X-Google-Sender-Auth: JT9JJ-ppc6ZXYJBHHXDPrklfXBw
Message-ID: <CACPM=kWr7X4ACV1r40HL_kQt5iJjh8Nek1GWqqxNJsKaE2zL-A@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Split driver into .c and .h files.
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

2012/1/1 Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
>> Split the driver into via-rhine.c and via-rhine.h like it should be.
>> There is also a bit of cleanup of checkpatch warnings, other than that,
>> there is no changes to how the code works, it is plain refactoring.
>
> Please don't do that. The .h won't be used elsewhere. It's useless
> (and register definitions stay barely readable).

Hmm, I see your point, was just trying to make the two via drivers more alike :)

> Roger, any comment regarding patches #1 .. #3 ?
>
> rhine_task_{enable / disable} should be balanced in open / close and
> suspend / resume, ok.
>
> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
