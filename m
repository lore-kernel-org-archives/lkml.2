Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1BCPuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:50:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932226Ab1BCPuB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:50:01 -0500
MIME-Version: 1.0
In-Reply-To: <20110203112316.GA3718@linux-yscl.site>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera> <20110203112316.GA3718@linux-yscl.site>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Feb 2011 07:42:05 -0800
Message-ID: <AANLkTikELiGS+fM5WguZS=Fo-sSXmej1UnKWqCFmnE0k@mail.gmail.com>
Subject: Re: 2.6.38-rc3-git1: Reported regressions 2.6.36 -> 2.6.37
To: "Carlos R. Mafra" <crmafra2@gmail.com>, Keith Packard <keithp@keithp.com>,
        Dave Airlie <airlied@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 3:23 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> On Thu  3.Feb'11 at  1:03:41 +0100, Rafael J. Wysocki wrote:
>>
>> If you know of any other unresolved post-2.6.36 regressions, please let us know
>> either and we'll add them to the list.  Also, please let us know if any
>> of the entries below are invalid.
>
> I'm sorry if I'm overlooking something, but as far as I can see the regression
> reported here:
>
> https://lkml.org/lkml/2011/1/24/457
>
> is not in the list (update on that report: reverting that commit on top of
> 2.6.37 fixes the issue).

Ok, added Keith and Dave to the cc, since they are the signers of that commit.

> After some time, I also ended up finding an earlier report in the kernel bugzilla
> which I think is the same regression (it was bisected to the same commit):
>
> https://bugzilla.kernel.org/show_bug.cgi?id=24982
>
> but I do not see it in the list either, even though it's marked as a
> regression in the bugzilla.
>
> The issue was also present in 2.6.38-rc2 last time I tested.

Just to confirm, can you also check -rc3? I'm pretty sure nothing has
changed, but there were a few drm patches after -rc2, so it's alsways
good to double-check.

Keithp?

                        Linus
