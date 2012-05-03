Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2ECOUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2ECOUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:20:46 -0400
Subject: Re: [patch V2 09/31] cx6: Use generic init_task
From: Mark Salter <msalter@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 03 May 2012 09:45:59 -0400
In-Reply-To: <20120503085034.412398724@linutronix.de>
References: <20120503083859.991965503@linutronix.de>
	 <20120503085034.412398724@linutronix.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1336052760.9422.6.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 09:02 +0000, Thomas Gleixner wrote:
> Same code. Use the generic version.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mark Salter <msalter@redhat.com>
> ---
>  arch/c6x/Kconfig          |    1 +
>  arch/c6x/kernel/process.c |   16 ----------------
>  2 files changed, 1 insertion(+), 16 deletions(-)
> 
> Index: tip/arch/c6x/Kconfig
> ===================================================================
> --- tip.orig/arch/c6x/Kconfig
> +++ tip/arch/c6x/Kconfig
> @@ -15,6 +15,7 @@ config TMS320C6X
>         select IRQ_DOMAIN
>         select OF
>         select OF_EARLY_FLATTREE
> +       select HAVE_GENERIC_INIT_TASK

I'd like to keep this list in alphabetical order.

Change cx6 to c6x in subject.

It does test okay with no problems on c6x.





