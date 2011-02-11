Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1BKORy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:17:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:54988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab1BKORx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:17:53 -0500
Date: Fri, 11 Feb 2011 15:17:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fix printk typo WARING
In-Reply-To: <1297204087.1748.17.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102111517430.2160@pobox.suse.cz>
References: <1297204087.1748.17.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 697dc34..303be81 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -4026,7 +4026,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
>  static int bad_ioapic(unsigned long address)
>  {
>  	if (nr_ioapics >= MAX_IO_APICS) {
> -		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
> +		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
>  		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
>  		return 1;

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
