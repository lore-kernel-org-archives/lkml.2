Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0JZINb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:13:31 -0400
Received: from smtp.fullrate.dk ([90.185.1.42]:58496 "EHLO smtp.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab0JZIN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:13:29 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 04:13:29 EDT
Date: Tue, 26 Oct 2010 10:05:19 +0200 (CEST)
From: Martin Nybo Andersen <tweek@tweek.dk>
To: Dragoslav Zaric <zaricdragoslav@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Tickles scheduler
In-Reply-To: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1010260959250.10975@odin.tweek.dk>
References: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Dragoslav Zaric wrote:

> [...]
>
> Is it at all possible to implement kernel without ticking, spin system
> by events and periods ?

You can compile with CONFIG_NO_HZ=n if you want a ticking kernel.

> Maybe ticking is still best solution to have fast responding system ?

My guesses are that it has already been benchmarked for speed, but you can 
still test it yourself.
At least power usage/battery times is much better with a tickless kernel.

> Kind regards
>
> -- 
> Dragoslav Zaric

-- 
Regards,
Martin
