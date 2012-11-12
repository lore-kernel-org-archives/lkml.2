Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2KLNYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:24:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48264 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab2KLNYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:24:37 -0500
Date: Mon, 12 Nov 2012 14:24:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3, v5] AMD64 EDAC: Add muli-domain support
Message-ID: <20121112132436.GC5162@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1352095526-6522-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1352095526-6522-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 02:05:24PM +0800, Daniel J Blueman wrote:
> Fix the handling of memory controller detection to index the array
> of detected Northbridges, allowing memory controllers over multiple
> PCI domains in federated systems eg using Numascale's NumaConnect/
> NumaChip.
> 
> v4: Generate linear Northbridge ID by indexing detected Northbridges
> v5: Reorder functions to prevent extra function declaration; merge 4th
>     patch; simplify Fam15h code; add detail to warning
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

Acked-by: Borislav Petkov <bp@alien8.de>

Btw, I don't have access to a multi-socket single-board AMD system right
now so would you please test the patchset on such a system too, if you
haven't done so yet?

Thanks a lot.

-- 
Regards/Gruss,
Boris.
