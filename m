Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab1KJAiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:38:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36916 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214Ab1KJAis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:38:48 -0500
Message-ID: <4EBB1CD7.6040502@zytor.com>
Date: Wed, 09 Nov 2011 16:37:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: David Daney <david.daney@cavium.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: binfmt_elf: Create Kconfig variable for PIE randomization.
References: <1320885178-24201-1-git-send-email-david.daney@cavium.com>
In-Reply-To: <1320885178-24201-1-git-send-email-david.daney@cavium.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 04:32 PM, David Daney wrote:
> Randomization of PIE load address is hard coded in binfmt_elf.c for
> X86 and ARM.  Create a new Kconfig variable
> (CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE) for this and use it instead.
> Thus architecture specific policy is pushed out of the generic
> binfmt_elf.c and into the architecture Kconfig files.
> 
> X86 and ARM Kconfigs are modified to select the new variable so there
> is no change in behavior.  A follow on patch will select it for MIPS
> too.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

