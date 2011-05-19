Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab1ESDdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:33:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:41590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab1ESDdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:33:35 -0400
Subject: Re: [PATCH] lib: Consolidate DEBUG_STACK_USAGE option
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-m32r@ml.linux-m32r.org,
        user-mode-linux-devel@lists.sourceforge.net, linux-sh@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>, sparclinux@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1304747831-2098-1-git-send-email-sboyd@codeaurora.org>
References: <1304747831-2098-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 13:32:07 +1000
Message-ID: <1305775927.7481.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 22:57 -0700, Stephen Boyd wrote:
> Most arches define CONFIG_DEBUG_STACK_USAGE exactly the same way.
> Move it to lib/Kconfig.debug so each arch doesn't have to define
> it. This obviously makes the option generic, but that's fine
> because the config is already used in generic code.
> 
> It's not obvious to me that sysrq-P actually does anything
> different with this option enabled, but I erred on the side of
> caution by keeping the most inclusive wording.

Sorry for the delay...

For powerpc:

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


