Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030886Ab2B2HtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:49:12 -0500
Received: from mail.southpole.se ([193.12.106.18]:48755 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030857Ab2B2HtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:49:10 -0500
Message-ID: <1330501749.2964.4.camel@crucifix>
Subject: Re: [PATCH 2/2] OpenRISC: IRQ: Include module.h
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 08:49:09 +0100
In-Reply-To: <1330476393-14264-2-git-send-email-richard@nod.at>
References: <1330476393-14264-1-git-send-email-richard@nod.at>
	 <1330476393-14264-2-git-send-email-richard@nod.at>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 01749-05838
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks.  There is already a patch in linux-next for this.

However, the patch in linux-next pulls in export.h instead of module.h.
I think export.h is the correct header file to be using here, but let me
know if you see it differently.

Thanks for helping out with build-testing the OpenRISC arch... much
appreciated.

/Jonas

On Wed, 2012-02-29 at 01:46 +0100, Richard Weinberger wrote:
> Fixes:
>   CC      arch/openrisc/kernel/irq.o
> arch/openrisc/kernel/irq.c:35:1: warning: data definition has no type or storage class
> arch/openrisc/kernel/irq.c:35:1: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL’
> arch/openrisc/kernel/irq.c:35:1: warning: parameter names (without types) in function declaration
> arch/openrisc/kernel/irq.c:42:1: warning: data definition has no type or storage class
> arch/openrisc/kernel/irq.c:42:1: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL’
> arch/openrisc/kernel/irq.c:42:1: warning: parameter names (without types) in function declaration
> arch/openrisc/kernel/irq.c:173:1: warning: data definition has no type or storage class
> arch/openrisc/kernel/irq.c:173:1: warning: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL_GPL’
> arch/openrisc/kernel/irq.c:173:1: warning: parameter names (without types) in function declaration
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/openrisc/kernel/irq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
> index 59b3023..f917925 100644
> --- a/arch/openrisc/kernel/irq.c
> +++ b/arch/openrisc/kernel/irq.c
> @@ -14,6 +14,7 @@
>   *      2 of the License, or (at your option) any later version.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/ptrace.h>
>  #include <linux/errno.h>
>  #include <linux/interrupt.h>


