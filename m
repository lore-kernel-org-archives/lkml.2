Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1CPMkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:40:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1CPMkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:40:16 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, libc-alpha@sourceware.org,
        GCC Development <gcc@gcc.gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        x32-abi@googlegroups.com
Subject: Re: X32 psABI status update
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103160030.27594.vapier@gentoo.org>
	<AANLkTimk3dfOBoPhGQ8NeOYY5rKdsefPm8gTJ-75vg3-@mail.gmail.com>
	<201103160124.42939.vapier__14164.6524928094$1300277836$gmane$org@gentoo.org>
X-Yow: Why is it that when you DIE, you can't take your
 HOME ENTERTAINMENT CENTER with you??
Date: Wed, 16 Mar 2011 13:39:57 +0100
In-Reply-To: <201103160124.42939.vapier__14164.6524928094$1300277836$gmane$org@gentoo.org>
	(Mike Frysinger's message of "Wed, 16 Mar 2011 01:24:41 -0400")
Message-ID: <m3ipvjs0gy.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> writes:

> but it doesnt say what to do for binutils or gcc itself.  obviously you cant 
> use the -mx32 flag when building the cross gcc for the first time since the 
> current native gcc wont support it.

Of course, for a compiler tool the only thing that matters is the
target.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
