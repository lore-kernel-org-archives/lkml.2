Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1FPJPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:15:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:41494 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab1FPJPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:15:41 -0400
Date: Thu, 16 Jun 2011 11:15:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] scripts/gcc-goto.sh: fix a typo ("suport")
In-Reply-To: <1308176266-31827-1-git-send-email-j.neuschaefer@gmx.net>
Message-ID: <alpine.LNX.2.00.1106161115320.22872@pobox.suse.cz>
References: <1308176266-31827-1-git-send-email-j.neuschaefer@gmx.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Jonathan Neuschäfer wrote:

> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  scripts/gcc-goto.sh |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
> index 520d16b..98cffcb 100644
> --- a/scripts/gcc-goto.sh
> +++ b/scripts/gcc-goto.sh
> @@ -1,5 +1,5 @@
>  #!/bin/sh
> -# Test for gcc 'asm goto' suport
> +# Test for gcc 'asm goto' support
>  # Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
>  
>  echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"

Applied.

-- 
Jiri Kosina
SUSE Labs
