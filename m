Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab0KSAr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:47:27 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:47270 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757069Ab0KSArY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:47:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAB9X5UxLd/sX/2dsb2JhbAAHgz3NYpB4gSKDNnMEhFo
X-IronPort-AV: E=Sophos;i="4.59,220,1288584000"; 
   d="scan'208";a="82927486"
Message-ID: <4CE5C919.7090504@teksavvy.com>
Date: Thu, 18 Nov 2010 19:47:21 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.37-rc2-git4: Reported regressions 2.6.35 -> 2.6.36
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
In-Reply-To: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-18 06:50 PM, Rafael J. Wysocki wrote:
> This message contains a list of some post-2.6.35 regressions introduced before
> 2.6.36, for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
>
> If you know of any other unresolved post-2.6.35 regressions, please let us know
> either and we'll add them to the list.  Also, please let us know if any
> of the entries below are invalid.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21652
> Subject		: several problems with intel graphics since 2.6.36
> Submitter	: Norbert Preining<preining@logic.at>
> Date		: 2010-10-27 14:32 (23 days old)
> Message-ID	:<20101027143252.GA8676@gamma.logic.tuwien.ac.at>
> References	: http://marc.info/?l=linux-kernel&m=128818998630241&w=2

That one is interesting to me.. I suspect it may be the same cause
as for https://bugzilla.kernel.org/show_bug.cgi?id=21952

I have one of those Samsung (N210) Netbooks here: works fine with 2.6.34 and 
earlier,
but fails to come out of suspend on 2.6.35/2.6.36 (haven't tried 2.6.37).

So perhaps add 21952 to the list, or link it to the 21652
(kind of amusing how similar the bug numbers are..).


My non-Intel graphics notebook (has ATI X1400 graphics) also has a resume
regression with 2.6.36.  But it does work fine with 2.6.35 (and earlier,
back many years).  As a result, I'm stuck with 2.6.35 for the time being,
and lack the time for a concerted debug effort on 2.6.36+ right now.

Cheers
