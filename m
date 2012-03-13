Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436Ab2CMKGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:06:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62231 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab2CMKGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <1330784327-7172-1-git-send-email-luciarosculete@gmail.com>
References: <1330784327-7172-1-git-send-email-luciarosculete@gmail.com>
Date: Tue, 13 Mar 2012 12:06:20 +0200
Message-ID: <CAEnQRZAitvn9R+fzgFSjvak2yv8dwnRepShR7Ws71uBqeJHs8A@mail.gmail.com>
Subject: Re: [PATCH] semaphore: fix comment
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Lucia Rosculete <luciarosculete@gmail.com>, jkosina@suse.cz
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 3, 2012 at 4:18 PM, Lucia Rosculete
<luciarosculete@gmail.com> wrote:
>         Replace "mutex" with "semaphore" in down_trylock comment
>
> Signed-off-by: Lucia Rosculete <luciarosculete@gmail.com>
> ---
>  kernel/semaphore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/semaphore.c b/kernel/semaphore.c
> index 60636a4..4567fc0 100644
> --- a/kernel/semaphore.c
> +++ b/kernel/semaphore.c
> @@ -118,7 +118,7 @@ EXPORT_SYMBOL(down_killable);
>  * down_trylock - try to acquire the semaphore, without waiting
>  * @sem: the semaphore to be acquired
>  *
> - * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
> + * Try to acquire the semaphore atomically.  Returns 0 if the semaphore has
>  * been acquired successfully or 1 if it it cannot be acquired.
>  *
>  * NOTE: This return value is inverted from both spin_trylock and
> --
> 1.7.6.3

Hello Jiri,

Can you have a look?

thanks,
Daniel.
