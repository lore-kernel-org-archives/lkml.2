Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0JXMzB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 08:55:01 -0400
Received: from www.tglx.de ([62.245.132.106]:45644 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab0JXMzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 08:55:00 -0400
Date: Sun, 24 Oct 2010 14:53:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] x86: APIC related clean up
Message-ID: <alpine.LFD.2.00.1010241449590.8736@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

Why the heck is this called cleanup ?

> 1. Merge acpi_register_lapic_address, smp_register_lapic_address, sfi_register_lapic_address
>

This part is a cleanup and makes some sense.

> 2. nox2apic support: disable x2apic for preenabled system or kexec path.

This part is adding and changing functionality, so it needs to be a
different series with a 0/N mail which explains what and why.

And please take your time addressing the review issues as this is
going to be 2.6.38 material if at all.

Thanks,

	tglx
