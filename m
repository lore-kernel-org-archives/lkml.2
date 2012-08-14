Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2HNXrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:47:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:33897 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2HNXrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:47:17 -0400
Date: Wed, 15 Aug 2012 01:47:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olof Johansson <olof@lixom.net>
cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/31] arm64: Exception handling
In-Reply-To: <20120814232907.GB19607@quad.lixom.net>
Message-ID: <alpine.LFD.2.02.1208150146460.32033@ionos>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-4-git-send-email-catalin.marinas@arm.com> <20120814232907.GB19607@quad.lixom.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Olof Johansson wrote:
> > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > new file mode 100644
> > index 0000000..8712a8e
> > --- /dev/null
> > +++ b/arch/arm64/kernel/traps.c
> [...]
> > +DEFINE_SPINLOCK(die_lock);
> 
> Should probably be static.

And RAW_
