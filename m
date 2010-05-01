Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0EBENX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 00:13:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:41257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0EBENS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 00:13:18 -0400
Date: Sat, 1 May 2010 11:07:15 -0700
From: Greg KH <gregkh@suse.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: trenn@suse.de, yinghai@kernel.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.31.13] Build failure at arch/x86/kernel/apic/io_apic.c
Message-ID: <20100501180715.GA7745@suse.de>
References: <201004120230.o3C2UhfQ050532@www262.sakura.ne.jp> <20100412024446.GA28141@suse.de> <201004120410.o3C4Axwe066941@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004120410.o3C4Axwe066941@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 01:10:59PM +0900, Tetsuo Handa wrote:
> Commit d539e5576605d048e6aeb21cbe3a8e71dc5eea81 "x86: Fix SCI on IOAPIC != 0"
> introduced "void setup_IO_APIC_irq_extra(u32 gsi)" which calls
> mp_find_ioapic() and mp_find_ioapic_pin().
> 
> This commit does not compile if CONFIG_X86_IO_APIC=y and CONFIG_ACPI=n .

Why would you want to build without ACPI on any modern system?  Anyway,
have a fix for this?

thanks,

greg k-h
