Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2JVNWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:22:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50607 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016Ab2JVNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:22:33 -0400
Message-ID: <1350912148.4951.7.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH V2 08/10] efi: Enable secure boot lockdown automatically
 when enabled in firmware
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Mon, 22 Oct 2012 14:22:28 +0100
In-Reply-To: <1348152065-31353-9-git-send-email-mjg@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-9-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 10:41 -0400, Matthew Garrett wrote:
> The firmware has a set of flags that indicate whether secure boot is enabled
> and enforcing. Use them to indicate whether the kernel should lock itself
> down.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  Documentation/x86/zero-page.txt  |  2 ++
>  arch/x86/boot/compressed/eboot.c | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/bootparam.h |  3 ++-
>  arch/x86/kernel/setup.c          |  3 +++
>  include/linux/cred.h             |  2 ++
>  5 files changed, 41 insertions(+), 1 deletion(-)

Probably wants an update to Documentation/x86/boot.txt too. But
otherwise,

Acked-by: Matt Fleming <matt.fleming@intel.com>


