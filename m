Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab1LORMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:12:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42273 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1LORL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:11:59 -0500
Message-ID: <4EEA2A5A.2050008@gmail.com>
Date: Thu, 15 Dec 2011 09:11:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3]arch:powerpc:sysdev:mpic.c Remove extra semicolon.
References: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what would be the status of these? should I resend/rebase to the current 
etc?..

On 11/21/2011 08:43 AM, Justin P. Mattock wrote:
> From: "Justin P. Mattock"<justinmattock@gmail.com>
>
> The patch below removes an extra semicolon.
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> CC: linuxppc-dev@lists.ozlabs.org
> CC: Paul Mackerras<paulus@samba.org>
> ---
>   arch/powerpc/sysdev/mpic.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> index 8c7e852..b3fa3d7 100644
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@ -901,7 +901,7 @@ int mpic_set_irq_type(struct irq_data *d, unsigned int flow_type)
>   	if (vold != vnew)
>   		mpic_irq_write(src, MPIC_INFO(IRQ_VECTOR_PRI), vnew);
>
> -	return IRQ_SET_MASK_OK_NOCOPY;;
> +	return IRQ_SET_MASK_OK_NOCOPY;
>   }
>
>   void mpic_set_vector(unsigned int virq, unsigned int vector)

