Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1GUHFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:05:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46169 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1GUHFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:46 -0400
Date: Thu, 21 Jul 2011 09:04:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: constify PCI raw ops structures
Message-ID: <20110721070459.GB9216@elte.hu>
References: <4E258C82020000780004E3C2@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E258C82020000780004E3C2@nat28.tlf.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> As with any other such change, the goal is to prevent inadvertent
> writes to these structures (assuming DEBUG_RODATA is enabled), and to
> separate data (possibly frequently) written to from such never getting
> modified.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/include/asm/pci_x86.h |    6 +++---
>  arch/x86/pci/ce4100.c          |    2 +-
>  arch/x86/pci/common.c          |    4 ++--
>  arch/x86/pci/direct.c          |    6 +++---
>  arch/x86/pci/mmconfig_32.c     |    2 +-
>  arch/x86/pci/mmconfig_64.c     |    2 +-
>  arch/x86/pci/numaq_32.c        |    2 +-
>  arch/x86/pci/olpc.c            |    2 +-
>  arch/x86/pci/pcbios.c          |    4 ++--
>  9 files changed, 15 insertions(+), 15 deletions(-)

Reviewed-by: Ingo Molnar <mingo@elte.hu>

It's a patch for Jesse's PCI tree i suspect.

Thanks,

	Ingo
