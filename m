Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1CKDiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:38:04 -0500
Received: from ozlabs.org ([203.10.76.45]:56759 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab1CKDiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:38:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.38-rc8, patch] minor ANSI prototype sparse fix
In-Reply-To: <AANLkTi=AdWh+oAe4ZVgUUxZffv1uHSPE3J1b8KZ=yS_7@mail.gmail.com>
References: <AANLkTi=AdWh+oAe4ZVgUUxZffv1uHSPE3J1b8KZ=yS_7@mail.gmail.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Fri, 11 Mar 2011 09:45:47 +1030
Message-ID: <87aah24lek.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Mar 2011 22:01:47 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> Fix function prototype to be ANSI-C compliant, consistent with other
> function prototypes, addressing a sparse warning.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Thanks, applied.

FYI: your patch was line-wrapped, fixed manually:

> diff --git a/kernel/module.c b/kernel/module.c
> index efa290e..be35185 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1627,7 +1627,7 @@ void unset_section_ro_nx(struct module *mod,
> void *module_region)
>  }
> 

Cheers,
Rusty.
