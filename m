Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1BMARf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 19:17:35 -0500
Received: from mail.lang.hm ([64.81.33.126]:54361 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab1BMAR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 19:17:28 -0500
Date: Sat, 12 Feb 2011 16:16:40 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
Subject: Re: [Bug #28622] radeon video lockup
In-Reply-To: <1z1FRILH7uF.A.ib.rfxVNB@chimera>
Message-ID: <alpine.DEB.2.00.1102121610460.4146@asgard.lang.hm>
References: <9Pzlq5PlEtH.A.DU.efxVNB@chimera> <1z1FRILH7uF.A.ib.rfxVNB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.36 and 2.6.37.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28622
> Subject		: radeon video lockup
> Submitter	: Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
> Date		: 2011-02-08 17:48 (5 days old)

hmm, I've occasionally been expericancing what sounds like a similar 
issue.

the screen locks, it doesn't respond to the keyboard (but caps lock still 
works), frequently the mouse pointer still moves, but you can't click on 
anything.

it ususally happens to me a few min after starting firefox (with 10-15 
windows holding a couple hundred tabs), so it could also be a firefox bug 
if it can capture the input and not release it.

I've experianced this on my T61 laptop, and my work machine (Radeon X1300 
series)

I'm currently running ubuntu 10.10 which is 2.6.35-25, so if it is the 
same problem, it wasn't introduced between 2.6.36 and 2.6.37.

like the OP of the bug report, this is not something that happens 
frequently, but I don't do much that stresses the video, so starting all 
these tabs is about as hard as I drive it.

David Lang
