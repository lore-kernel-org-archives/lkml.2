Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab2AEQ3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:29:32 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:52284 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2AEQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:29:30 -0500
Date: Thu, 5 Jan 2012 17:20:13 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
Message-ID: <20120105162013.GA19440@electric-eye.fr.zoreil.com>
References: <20111230215024.GA5513@electric-eye.fr.zoreil.com> <CACPM=kUxSRhDc2EqgceBRTFgBei7dh3_n7bPyoH=8aNC_uq4FA@mail.gmail.com> <20111230221938.GA6197@electric-eye.fr.zoreil.com> <CACPM=kXAr46BXAc3t8puRB37NeFy_ZEOWZa0H=DnSioagSLpxA@mail.gmail.com> <CACPM=kWn41S85eLgj4G+c6cN0WBgqF=6MigSwa9QBOxD1Uh64A@mail.gmail.com> <20111231121710.GB9842@electric-eye.fr.zoreil.com> <CACPM=kX2B6p6CSs+s-5WUbQCLa0WZW5K9Rr+hnB5VCxkEmh=8w@mail.gmail.com> <20120103223243.GB8563@electric-eye.fr.zoreil.com> <CACPM=kUhBydaVDQaxs7BaB_ZkFRa2p6cVme-77Gbsk+QDk=MFA@mail.gmail.com> <CACPM=kWL+Z6PH268qg=i0Nafrouq4O25+uFf8WLcE08azqpqpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPM=kWL+Z6PH268qg=i0Nafrouq4O25+uFf8WLcE08azqpqpA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
[...]
> Sorry for repeating myself David, but would it be possible to get this
> into net-next for 3.4 inclusion ?

You should not expect #net-next for 3.4 to open before the merge window
for 3.3 is closed.

With due consideration for his freedom of will and action, David can not
take the current patchkit because he needs a formal submission of a complete
set where #3 is fixed. Our last friday's exchange does not count as one.

I understand it is important for you, it will be sent, ok ?

For future reference, you can see what is going on here :

http://patchwork.ozlabs.org/project/netdev/list/?state=*&q=via-rhine

/me returns to paperwork...

-- 
Ueimor
