Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2LSIrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 03:47:24 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23879 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2LSIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 03:47:15 -0500
Date: Wed, 19 Dec 2012 09:47:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Howells <dhowells@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Provide guards in uapi/asm/setup.h to prevent
  deletion by patch
Message-ID: <20121219094707.7372150b@endymion.delvare>
In-Reply-To: <20121217144932.7769.91648.stgit@warthog.procyon.org.uk>
References: <20121217144924.7769.69501.stgit@warthog.procyon.org.uk>
	<20121217144932.7769.91648.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 14:49:32 +0000, David Howells wrote:
> Provide reinclusion guards in the empty uapi/asm/setup.h to make sure that the
> patch program doesn't delete it.
> 
> However, should some part of asm/hw_setup.h actually be exported here, or,
> possibly, should the entire uapi file be removed?  In v3.6, though the file
> was marked for export to userspace, it had nothing outside of __KERNEL__.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jean Delvare <khali@linux-fr.org>
> ---
> 
>  arch/x86/include/uapi/asm/setup.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/setup.h b/arch/x86/include/uapi/asm/setup.h
> index e69de29..96a4d53 100644
> --- a/arch/x86/include/uapi/asm/setup.h
> +++ b/arch/x86/include/uapi/asm/setup.h
> @@ -0,0 +1,4 @@
> +#ifndef _UAPI_ASM_X86_SETUP_H
> +#define _UAPI_ASM_X86_SETUP_H
> +
> +#endif /* _UAPI_ASM_X86_SETUP_H */
> 

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
