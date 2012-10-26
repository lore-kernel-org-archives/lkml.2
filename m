Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab2JZJvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:51:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44955 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab2JZJvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:51:12 -0400
Message-ID: <1351245068.5303.50.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] EFI fixes for v3.7
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Date: Fri, 26 Oct 2012 10:51:08 +0100
In-Reply-To: <20121026082223.GA27378@gmail.com>
References: <1351238331.5303.23.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20121026082223.GA27378@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:22 +0200, Ingo Molnar wrote:
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > Hi guys,
> > 
> > The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:
> > 
> >   Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.7
> > 
> > for you to fetch changes up to 5189c2a7c7769ee9d037d76c1a7b8550ccf3481c:
> > 
> >   x86: efi: Turn off efi_enabled after setup on mixed fw/kernel (2012-10-25 19:09:40 +0100)
> > 
> > ----------------------------------------------------------------
> > EFI updates for 3.7
> > 
> > Fix oops with EFI variables on mixed 32/64-bit firmware/kernels and
> > document EFI git repository location on kernel.org.
> > 
> > ----------------------------------------------------------------
> > Matt Fleming (1):
> >       MAINTAINERS: Add EFI git repository location
> > 
> > Olof Johansson (1):
> >       x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
> > 
> >  MAINTAINERS                 |  1 +
> >  arch/x86/include/asm/efi.h  |  1 +
> >  arch/x86/kernel/setup.c     | 12 ++++++++++++
> >  arch/x86/platform/efi/efi.c | 18 ++++++++++--------
> >  4 files changed, 24 insertions(+), 8 deletions(-)
> 
> So, this conflicted with this pending EFI fix in tip:x86/urgent:
> 
>   3e8fa263a970 x86/efi: Fix oops caused by incorrect set_memory_uc() usage
> 
> I've pulled it and fixed up the conflict - please double check 
> the end result.

Damn. Sorry about that.

The fixup looks good, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center

