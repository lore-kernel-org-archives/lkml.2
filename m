Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1LEMwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:52:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42035 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab1LEMwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:52:43 -0500
Date: Mon, 5 Dec 2011 13:51:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marc Leeman <marc.leeman@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH]: expose FORCE_MAX_ZONEORDER on x86
Message-ID: <20111205125107.GH3143@elte.hu>
References: <CAH+fs=-WkbLgB-wsNEPS_OnvqwK9eChMCrMOudjtg7bu2ZtqHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH+fs=-WkbLgB-wsNEPS_OnvqwK9eChMCrMOudjtg7bu2ZtqHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marc Leeman <marc.leeman@gmail.com> wrote:

> Larger blocks of memory can be required for e.g. higher resolutions on
> some capture card drivers; this patch just enables an already
> available configuration option on x86 (it was already exposed on other
> architectures).
> 
> The default is set to 11, as in
> ./include/linux/mmzone.h
> 
> [barco@nmgserver001 linux-3.0]$ find . -name Kconfig | xargs grep
> FORCE_MAX_ZONEORDER
> ./arch/ia64/Kconfig:config FORCE_MAX_ZONEORDER
> ./arch/cris/Kconfig:config FORCE_MAX_ZONEORDER
> ./arch/arm/Kconfig:config FORCE_MAX_ZONEORDER
> ./arch/s390/Kconfig:config FORCE_MAX_ZONEORDER
> ./arch/mips/Kconfig:config FORCE_MAX_ZONEORDER
> ./arch/sh/mm/Kconfig:config FORCE_MAX_ZONEORDER
> ./arch/blackfin/Kconfig:config FORCE_MAX_ZONEORDER
> ./arch/powerpc/Kconfig:config FORCE_MAX_ZONEORDER
> 
> 
> 
> -- 
> br, marc
> 
> The best approach for you requires two steps. The first step is
> reading the Manual.
>     Wolfgang Denk - u-boot mailing list

> From 8ad64edbf92ac8e0253677bd3f9ad376ce3be7d1 Mon Sep 17 00:00:00 2001
> From: Marc Leeman <marc.leeman@gmail.com>
> Date: Wed, 26 Oct 2011 10:35:24 +0200
> Subject: [PATCH] KConfig x86: enable FORCE_MAX_ZONEORDER

I guess we could do this - but you forgot to sign off on your 
patch.

Thanks,

	Ingo
