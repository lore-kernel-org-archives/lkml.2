Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab2JHO22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:28:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52485 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab2JHO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:28:25 -0400
Message-ID: <1349706500.15966.165.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86: efi: Turn off efi_enabled after setup on mixed
 fw/kernel
From: Matt Fleming <matt@console-pimps.org>
To: Olof Johansson <olof@lixom.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mk@dee.su,
        Marko Kohtala <marko.kohtala@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date: Mon, 08 Oct 2012 15:28:20 +0100
In-Reply-To: <1345412920-10906-1-git-send-email-olof@lixom.net>
References: <1345412920-10906-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 14:48 -0700, Olof Johansson wrote:
> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
> efi_enabled once setup is done. Beyond setup, it is normally used to
> determine if runtime services are available and we will have none.
> 
> This will resolve issues stemming from efivars modprobe panicking on a
> 32/64-bit setup, as well as some reboot issues on similar setups.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: stable@kernel.org # 3.4 and 3.5
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/kernel/setup.c     | 11 +++++++++++
>  arch/x86/platform/efi/efi.c | 14 ++++++++------
>  2 files changed, 19 insertions(+), 6 deletions(-)

Olof,

Would you mind resubmitting this patch and addressing Maarten's comment
about efi_is_native()?

-- 
Matt Fleming, Intel Open Source Technology Center

