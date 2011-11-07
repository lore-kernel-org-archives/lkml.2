Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1KGLbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:31:16 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44905 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab1KGLbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:31:15 -0500
Subject: Re: [PATCH] x86, efi: Convert efi_phys_get_time() args to physical
 addresses
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Zhang Rui <rui.zhang@intel.com>
In-Reply-To: <1318330333-4617-1-git-send-email-matt@console-pimps.org>
References: <1318330333-4617-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 11:31:11 +0000
Message-ID: <1320665471.3572.110.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 11:52 +0100, Matt Fleming wrote:
> From: Maurice Ma <maurice.ma@intel.com>
> 
> Because callers of efi_phys_get_time() pass virtual stack addresses as
> arguments, we need to find their corresponding physical addresses and
> when calling GetTime() in physical mode.
> 
> Without this patch the following line is printed on boot,
> 
> 	"Oops: efitime: can't read time!"
> 
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Maurice Ma <maurice.ma@intel.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/platform/efi/efi.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Ping?


