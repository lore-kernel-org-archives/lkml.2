Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1DRPet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:34:49 -0400
Received: from sycorax.lbl.gov ([128.3.11.121]:40276 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1DRPeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:34:44 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #32902] 2.6.39-rc1 doesn't boot on thinkpad t61p x86_64
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
	<_H4l51C1wXN.A.-JC.2GuqNB@chimera>
Date: Mon, 18 Apr 2011 08:34:06 -0700
In-Reply-To: <_H4l51C1wXN.A.-JC.2GuqNB@chimera> (rjw@sisk.pl)
Message-ID: <87ipub7evl.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110016 (No Gnus v0.16) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.38. Please verify if it still should be listed and let the
> tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32902
> Subject		: 2.6.39-rc1 doesn't boot on thinkpad t61p x86_64
> Submitter	: Alex Romosan <romosan@sycorax.lbl.gov>
> Date		: 2011-04-03 19:41 (15 days old)
> Message-ID	: <87k4fbnmw8.fsf@sycorax.lbl.gov>
> References	: http://marc.info/?l=linux-kernel&m=130186054431678&w=2
>

my laptop works again with 2.6.39-rc3 (except the boot process hangs at
waiting for /dev to be populated.... if i hit Ctrl-C then the booting
proceeds normally. this doesn't happen with 2.6.38) so probably this bug
can be closed.

--alex-- 

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
