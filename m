Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2F2PgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:36:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:23953 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab2F2PgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159753058"
Date: Fri, 29 Jun 2012 17:47:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3] mfd/ab8500: print switch off cause
Message-ID: <20120629154721.GN22806@sortiz-mobl>
References: <1338883894-20388-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338883894-20388-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jun 05, 2012 at 10:11:34AM +0200, Linus Walleij wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Instead of just printing the register value, also output some
> description of the value.
> 
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Use printk() with KERN_CONT instead of separate dev_* or
>   printk() calls. (Review comment from Joe Perches.)
> ChangeLog v1->v2:
> - Print each cause on its own line with a tab to avoid missing
>   initial cause heading if loglevel < info.
> ---
>  drivers/mfd/ab8500-core.c |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
Patch applied, sorry for missing this one during the 3.5 merge window.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
