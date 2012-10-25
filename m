Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab2JYQEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:04:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab2JYQEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:04:38 -0400
Date: Thu, 25 Oct 2012 18:04:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] README: document "make olddefconfig"
In-Reply-To: <20121024172243.GA6707@www.outflux.net>
Message-ID: <alpine.LNX.2.00.1210251804230.26510@pobox.suse.cz>
References: <20121024172243.GA6707@www.outflux.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Kees Cook wrote:

> While "olddefconfig" was documented in "make help", it was not mentioned
> in the README.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  README |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/README b/README
> index f32710a..a24ec89 100644
> --- a/README
> +++ b/README
> @@ -180,6 +180,10 @@ CONFIGURING the kernel:
>                          with questions already answered.
>                          Additionally updates the dependencies.
>  
> +     "make olddefconfig"
> +                        Like above, but sets new symbols to their default
> +                        values without prompting.
> +
>       "make defconfig"   Create a ./.config file by using the default
>                          symbol values from either arch/$ARCH/defconfig

OK, I am taking this one, thanks.

-- 
Jiri Kosina
SUSE Labs
