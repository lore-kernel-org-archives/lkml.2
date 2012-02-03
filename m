Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2BCL3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:29:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63384 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2BCL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:29:37 -0500
MIME-Version: 1.0
In-Reply-To: <1328255503-17575-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1328255503-17575-1-git-send-email-xiyou.wangcong@gmail.com>
Date: Fri, 3 Feb 2012 16:59:35 +0530
Message-ID: <CA+7sy7C34f8MVAhf_+95Cm==-ZcSwxG3ybMcdEyXVHaUVFgNxA@mail.gmail.com>
Subject: Re: [Patch] mips: do not redefine BUILD_BUG()
From: "Jayachandran C." <c.jayachandran@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Hillf Danton <dhillf@gmail.com>,
        linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 1:21 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On mips, we got
>
> include/linux/kernel.h:717:1: error: "BUILD_BUG" redefined
> arch/mips/include/asm/page.h:43:1: error: this is the location of the previous definition
> make[3]: *** [arch/mips/sgi-ip27/ip27-console.o] Error 1
> make[2]: *** [arch/mips/sgi-ip27] Error 2
> make[1]: *** [arch/mips] Error 2
> make: *** [sub-make] Error 2
>
> use generic BUILD_BUG() instead of re-defining one.
>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

This is already fixed in linux-mips.org repository:

commit 2f5d5510507626ee799b6d1304d154569b6dfe05
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Mon Jan 16 12:38:05 2012 +0100

    MIPS: Remove temporary kludge from <asm/page.h>

JC.
