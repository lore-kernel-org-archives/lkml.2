Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2ACWsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:48:20 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:32930 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab2ACWlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:52 -0500
Date: Tue, 3 Jan 2012 23:32:43 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
Message-ID: <20120103223243.GB8563@electric-eye.fr.zoreil.com>
References: <CACPM=kVBxcL1_Z9zVvnEEdEgAc0rbAAbzkcocz4OYWQ2xn6VmQ@mail.gmail.com> <20111230180347.GA3647@electric-eye.fr.zoreil.com> <CACPM=kXWXUE+JcVhkz-6tGZ2YyteN9sGA80+Pnw6+LaJ-eNWBA@mail.gmail.com> <20111230215024.GA5513@electric-eye.fr.zoreil.com> <CACPM=kUxSRhDc2EqgceBRTFgBei7dh3_n7bPyoH=8aNC_uq4FA@mail.gmail.com> <20111230221938.GA6197@electric-eye.fr.zoreil.com> <CACPM=kXAr46BXAc3t8puRB37NeFy_ZEOWZa0H=DnSioagSLpxA@mail.gmail.com> <CACPM=kWn41S85eLgj4G+c6cN0WBgqF=6MigSwa9QBOxD1Uh64A@mail.gmail.com> <20111231121710.GB9842@electric-eye.fr.zoreil.com> <CACPM=kX2B6p6CSs+s-5WUbQCLa0WZW5K9Rr+hnB5VCxkEmh=8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPM=kX2B6p6CSs+s-5WUbQCLa0WZW5K9Rr+hnB5VCxkEmh=8w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
[...]
> Is there anything else I should try out?

Your computer is supposed to be moderately underpowered. Find someone
with an heavily overpowered one.

> Also, would it be possible to push these changes to mainline as

Probably. There has not been much objection nor comments so far.

> another CONFIG option (not sure if thats possible), so more people can
> enable it and test it? :)

I'd rather not. It would not be terribly elegant and more CONFIG options
would not imply more testing.

-- 
Ueimor
