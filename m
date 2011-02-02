Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1BBKd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:33:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1BBKdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:33:54 -0500
Date: Wed, 2 Feb 2011 11:33:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: tony.luck@intel.com, fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, megaraidlinux@lsi.com,
        James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net
Subject: Re: [PATCH 1/8]arch:ia64:perfmon.h change a typo comamnd to
 command
In-Reply-To: <1296623130-5130-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1102021132330.2160@pobox.suse.cz>
References: <1296623130-5130-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011, Justin P. Mattock wrote:

> The below patch fixes a typo comamnd to command.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/ia64/include/asm/perfmon.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/perfmon.h b/arch/ia64/include/asm/perfmon.h
> index 7f3333d..d551183 100644
> --- a/arch/ia64/include/asm/perfmon.h
> +++ b/arch/ia64/include/asm/perfmon.h
> @@ -7,7 +7,7 @@
>  #define _ASM_IA64_PERFMON_H
>  
>  /*
> - * perfmon comamnds supported on all CPU models
> + * perfmon commands supported on all CPU models

I have consended all the patches in this thread (modulo the staging ones) 
into one and applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
