Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1BTXmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 18:42:25 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19944 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab1BTXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 18:42:24 -0500
Date: Mon, 21 Feb 2011 00:41:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tino Keitel <tino@tikei.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] .gitignore: ignore *.xz files
In-Reply-To: <1298244509-11484-1-git-send-email-tino@tikei.de>
Message-ID: <alpine.LNX.2.00.1102210039250.20470@swampdragon.chaosbits.net>
References: <1298244509-11484-1-git-send-email-tino@tikei.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Tino Keitel wrote:

> The kernel image can now be xz compressed. Ignore such files.
> 
> Signed-off-by: Tino Keitel <tino@tikei.de>
> ---
>  .gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 8faa6c0..c0128d3 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -29,6 +29,7 @@ modules.builtin
>  *.bz2
>  *.lzma
>  *.lzo
> +*.xz
>  *.patch
>  *.gcno
>  

Makes sense to me.

Acked-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

