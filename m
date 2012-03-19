Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030957Ab2CSMYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:24:48 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60034 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2CSMYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <1332156983-9844-1-git-send-email-laura@rosedu.org>
References: <1332156983-9844-1-git-send-email-laura@rosedu.org>
Date: Mon, 19 Mar 2012 14:24:46 +0200
Message-ID: <CAEnQRZC_M_c-TaCGrcG-QQHi3cSosoX336M4LDovG6=EQfUD_g@mail.gmail.com>
Subject: Re: [PATCH] Spell fix in fs/proc/kcore.c
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Laura Vasilescu <laura@rosedu.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 1:36 PM, Laura Vasilescu <laura@rosedu.org> wrote:
> ---
>  fs/proc/kcore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index d245cb2..e5e69af 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -513,7 +513,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
>
>                                n = copy_to_user(buffer, (char *)start, tsz);
>                                /*
> -                                * We cannot distingush between fault on source
> +                                * We cannot distinguish between fault on source
>                                 * and fault on destination. When this happens
>                                 * we clear too and hope it will trigger the
>                                 * EFAULT again.
> --
> 1.7.2.5

That's nice. Thanks for your contribution.

Anyhow, please review this:
* add a Signed-off-by line
* add a proper prefix to Subject (e.g: kcore: spell fix in ... )
* don't forget to Cc the maintainers (run ./scripts/get_maintainer.pl
<your_patch>)

Daniel.
