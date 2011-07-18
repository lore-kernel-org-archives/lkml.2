Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1GRVM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:12:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50751 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1GRVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:12:55 -0400
Date: Mon, 18 Jul 2011 16:12:48 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <m2d3h7b8pv.fsf@bob.laptop.org>
Message-ID: <alpine.DEB.2.02.1107181606290.1677@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <m2sjqa2q93.fsf@bob.laptop.org> <alpine.DEB.2.02.1107131031360.3174@lazy> <201107131835.25217.arnd@arndb.de> <alpine.DEB.2.02.1107131144250.3174@lazy> <m21uxu2k96.fsf@bob.laptop.org>
 <alpine.DEB.2.02.1107131157440.3174@lazy> <m2wrfm1537.fsf@bob.laptop.org> <alpine.DEB.2.02.1107181535250.1677@lazy> <m2zkkbb9vn.fsf@bob.laptop.org> <alpine.DEB.2.02.1107181546100.1677@lazy> <m2d3h7b8pv.fsf@bob.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> I see, thanks.  So we're lacking any data on what speed the card would
> normally provide.  Perhaps you could try that card on a different
> controller, just so we're able to see whether it's usually possible
> to get closer to 45M/sec with it?

Sure, let me generate some data on based on Ricoh R5C822.


>
> I think I'll take your patch as-is for 3.1 -- since if there is a
> performance degradation, it's on cards that simply don't work at all
> right now -- and if you're able to work on a followup patch that only
> performs the clock-lowering after the first error, I think that'd be a
> handy patch to have around.  Does that sound good?
>

That sounds good to me, that way we limit degradation in performance only 
to previously non-working cards. I will send the V2 soon.

> Thanks!
>
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
>
Thanks a ton.
--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
