Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1GMT6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:58:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59736 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1GMT6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:58:33 -0400
Date: Wed, 13 Jul 2011 20:58:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] efi: merge x86 and ia64 code
Message-ID: <20110713195827.GA9910@srcf.ucam.org>
References: <1310502243-19306-1-git-send-email-mjg@redhat.com>
 <4E1DEAA2.80208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1DEAA2.80208@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 11:57:38AM -0700, H. Peter Anvin wrote:

> I get a build error on x86-32:
> 
> /home/hpa/kernel/linux-2.6-tip.efi/arch/x86/platform/efi/efi_32.c:43:
> error: conflicting types for ‘efi_call_phys_prelog’
> /home/hpa/kernel/linux-2.6-tip.efi/arch/x86/include/asm/efi.h:73: note:
> previous declaration of ‘efi_call_phys_prelog’ was here
> /home/hpa/kernel/linux-2.6-tip.efi/arch/x86/platform/efi/efi_32.c:85:
> error: conflicting types for ‘efi_call_phys_epilog’
> /home/hpa/kernel/linux-2.6-tip.efi/arch/x86/include/asm/efi.h:74: note:
> previous declaration of ‘efi_call_phys_epilog’ was here
> make[5]: *** [arch/x86/platform/efi/efi_32.o] Error 1

Oops.

It's sadly much easier to test IA64 than it is to test 32-bit EFI 
booting, but this one should at least build and link.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
