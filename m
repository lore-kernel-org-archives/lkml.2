Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2JJNnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:43:21 -0400
Received: from mga10.intel.com ([192.55.52.92]:41934 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754596Ab2JJNnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:43:20 -0400
Message-ID: <1349876587.15966.365.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86: Switch to vga console only if framebuffer details
 are missing
From: Matt Fleming <matt.fleming@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg@redhat.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 10 Oct 2012 14:43:07 +0100
In-Reply-To: <1347877748-11766-1-git-send-email-matt@console-pimps.org>
References: <1347877748-11766-1-git-send-email-matt@console-pimps.org>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 11:29 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> The efi_enabled variable has come to mean "Do we have EFI runtime
> services available?". However, lack of EFI runtime services does not
> mean that we should switch to using the VGA console. Provided that the
> boot loader passed the dimensions of the EFI framebuffer there is no
> reason we can't use efifb.
> 
> There's also no reason to check the memory type of 0xa0000 - whether
> or not that memory region is EFI_CONVENTIONAL_MEMORY is immaterial -
> the EFI framebuffer device will still work, and checking the EFI
> memory type of a memory region on a non-EFI machine is illogical.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/kernel/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Ping? Anybody got an opinion on this one?

