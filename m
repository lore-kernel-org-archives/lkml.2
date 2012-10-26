Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2JZIWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:22:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62959 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab2JZIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:22:28 -0400
Date: Fri, 26 Oct 2012 10:22:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [GIT PULL] EFI fixes for v3.7
Message-ID: <20121026082223.GA27378@gmail.com>
References: <1351238331.5303.23.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351238331.5303.23.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> Hi guys,
> 
> The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:
> 
>   Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.7
> 
> for you to fetch changes up to 5189c2a7c7769ee9d037d76c1a7b8550ccf3481c:
> 
>   x86: efi: Turn off efi_enabled after setup on mixed fw/kernel (2012-10-25 19:09:40 +0100)
> 
> ----------------------------------------------------------------
> EFI updates for 3.7
> 
> Fix oops with EFI variables on mixed 32/64-bit firmware/kernels and
> document EFI git repository location on kernel.org.
> 
> ----------------------------------------------------------------
> Matt Fleming (1):
>       MAINTAINERS: Add EFI git repository location
> 
> Olof Johansson (1):
>       x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
> 
>  MAINTAINERS                 |  1 +
>  arch/x86/include/asm/efi.h  |  1 +
>  arch/x86/kernel/setup.c     | 12 ++++++++++++
>  arch/x86/platform/efi/efi.c | 18 ++++++++++--------
>  4 files changed, 24 insertions(+), 8 deletions(-)

So, this conflicted with this pending EFI fix in tip:x86/urgent:

  3e8fa263a970 x86/efi: Fix oops caused by incorrect set_memory_uc() usage

I've pulled it and fixed up the conflict - please double check 
the end result.

Thanks,

	Ingo
