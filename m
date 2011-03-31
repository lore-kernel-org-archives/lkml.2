Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab1CaP6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:58:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246Ab1CaP6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:58:05 -0400
Date: Thu, 31 Mar 2011 17:57:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        rja@sgi.com
Subject: Re: [PATCH v3] x86: UV kdump reboot fix
Message-ID: <20110331155754.GC9827@elte.hu>
References: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Cliff Wickman <cpw@sgi.com> wrote:

> Diffed against 2.6.38-rc8 (current tip tree)

It does not apply here:

patching file arch/x86/kernel/apic/x2apic_uv_x.c
Hunk #1 FAILED at 23.
Hunk #2 succeeded at 35 (offset 1 line).
Hunk #3 succeeded at 812 (offset 1 line).
1 out of 3 hunks FAILED -- rejects in file arch/x86/kernel/apic/x2apic_uv_x.c

But yeah, the patch looks good now.

One minor nit, please watch out for the proper capitalization of sentences:

> +
> +	/*
> +	 * for a kdump kernel the reset must be BOOT_ACPI, not BOOT_EFI, as
> +	 * EFI is not enabled in the kdump kernel.
> +	 */
> +	if (is_kdump_kernel())
> +		reboot_type = BOOT_ACPI;

Thanks,

	Ingo
