Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2LTTAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:00:38 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41023 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2LTTAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:00:33 -0500
MIME-Version: 1.0
In-Reply-To: <20121220184525.GC21056@atomide.com>
References: <20121220163814.GA29557@quad.lixom.net> <20121220175639.GA14363@n2100.arm.linux.org.uk>
 <CAOesGMgxXmXUW2RP_5AxJ6Z5sRBhFJ2CQz4S12MwXAb3=ibYOA@mail.gmail.com> <20121220184525.GC21056@atomide.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2012 11:00:11 -0800
X-Google-Sender-Auth: O6mdLNxjukE968yedXPs8hTfUYk
Message-ID: <CA+55aFyiRPk0Qta35PBqMFqn+GkKaugqKJM3WHCT0JEJ1YohWw@mail.gmail.com>
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
To: Tony Lindgren <tony@atomide.com>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        maxime.ripard@free-electrons.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:45 AM, Tony Lindgren <tony@atomide.com> wrote:
>
> I'm seeing the "BUG: spinlock bad magic on CPU#0" issue
> reported and fixed here:
>
> http://marc.info/?l=linux-arm-kernel&m=135594868503683&w=2
>
> But that's probably been already posted as a proper patch
> somewhere?

Hmm. The patch there looks better than any alternative I can think of.
It uses the same spinlock name for the whole array, but I think it's
only used for lockdep printouts, so that should be fine.

Send me the patch with signed-off and tested-by, and perhaps have a
few more people test it. The powerpc and sparc people both use it in
their 32-bit versions and have responsible maintainers, so it might be
worth it double-checking with BenH and DaveM about it, just in case.
Added to the Cc.

                Linus
