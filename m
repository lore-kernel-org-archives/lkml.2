Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2KZNW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:22:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab2KZNW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:22:57 -0500
Date: Mon, 26 Nov 2012 14:22:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Cc: linux-kernel@vger.kernel.org, rob@landley.net, jj@chaosbits.net,
        linux-doc@vger.kernel.org, embedded@gentoo.org, kernel@gentoo.org
Subject: Re: [PATCH] Remove unnecessary declarations from
 Documentation/accounting/getdelays.c
In-Reply-To: <1353776064-25815-1-git-send-email-basile@opensource.dyc.edu>
Message-ID: <alpine.LNX.2.00.1211261422360.12570@pobox.suse.cz>
References: <1353776064-25815-1-git-send-email-basile@opensource.dyc.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2012, Anthony G. Basile wrote:

> From: "Anthony G. Basile" <basile@opensource.dyc.edu>
> 
> stime and utime are declared __u64 but are never used.  On a glibc system
> this is harmless lint, but on a uClibc system, because of the difference
> in they way header files stack, including stdio.h brings in time.h and
> this causes a name collision with stime.  Since these are useless anyhow,
> we remove them.
> 
> Signed-off-by: Anthony G. Basile <basile@opensource.dyc.edu>
> ---
>  Documentation/accounting/getdelays.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index 6f706ac..f8ebcde 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -51,7 +51,6 @@ int dbg;
>  int print_delays;
>  int print_io_accounting;
>  int print_task_context_switch_counts;
> -__u64 stime, utime;

Taking this through trivial.git, thanks.

-- 
Jiri Kosina
SUSE Labs
