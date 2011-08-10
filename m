Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab1HJN1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:27:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab1HJN13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:27:29 -0400
Message-ID: <4E428740.3030106@suse.cz>
Date: Wed, 10 Aug 2011 15:27:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: add extract-vmlinux
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
In-Reply-To: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.8.2011 15:52, Corentin Chary wrote:
> This script can be used to extract vmlinux from a compressed
> kernel image (bzImage, etc..). It's inspired from (a subset of)
> extract-ikconfig.

Nice.


> I don't know if this scripts really have this place in the kernel
> tree, but it's something a lot of people have been looking for (mainly
> people with xen < 4 that doesn't support bzImages at all).

I think it makes sense to have it in the tree.


> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
> ---
>  scripts/extract-vmlinux |   60 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)
>  create mode 100755 scripts/extract-vmlinux
> 
> diff --git a/scripts/extract-vmlinux b/scripts/extract-vmlinux
> new file mode 100755
> index 0000000..444f404
> --- /dev/null
> +++ b/scripts/extract-vmlinux
> @@ -0,0 +1,60 @@
> +#!/bin/sh
> +# ----------------------------------------------------------------------
> +# extract-vmlinux - Extract uncompressed vmlinux from a kernel image
> +#
> +# The obscure use of the "tr" filter is to work around older versions of
> +# "grep" that report the byte offset of the line instead of the pattern.
> +#
> +# Inspired from extract-ikconfig
> +# (c) 2009,2010 Dick Streefland <dick@streefland.net>
> +#
> +# (c) 2011      Corentin Chary <corentin.chary@gmail.com>
> +# Licensed under the terms of the GNU General Public License.

I guess you want to use the version 2 of the GPL?

Michal
