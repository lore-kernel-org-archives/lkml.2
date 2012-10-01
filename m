Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2JAQKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:10:39 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59196 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2JAQKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:10:36 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Mon, 1 Oct 2012 09:10:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20121001161029.GA21121@leaf>
References: <20121002005423.7530890bfcfaca06666dfc72@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002005423.7530890bfcfaca06666dfc72@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:54:23AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (sparc64 defconfig)
> produced this warning:
> 
> include/linux/efi.h:503:13: warning: 'efi_enter_virtual_mode' defined but not used [-Wunused-function]
> include/linux/efi.h:504:13: warning: 'efi_late_init' defined but not used [-Wunused-function]
> include/linux/efi.h:505:13: warning: 'efi_free_boot_services' defined but not used [-Wunused-function]
> 
> Introduced by commit f383a1e37bc3 ("efi: Add a stub for
> efi_enter_virtual_mode on non-x86") and following patches.  These
> function definitions should be "static inline".

Already fixed in the current version of those patches in tip.

- Josh Triplett
