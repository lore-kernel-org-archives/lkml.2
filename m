Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0DOSe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:34:59 -0400
Received: from lo.gmane.org ([80.91.229.12]:60838 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0DOSe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:34:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] Crypto: geode-aes: Fix some code style issues
Date: Thu, 15 Apr 2010 14:34:34 -0400
Message-ID: <20100415143434.7b39e55f@debian>
References: <1271351879-22805-1-git-send-email-chihau@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <1271351879-22805-1-git-send-email-chihau@gmail.com>
X-Newsreader: Claws Mail 3.7.5 (GTK+ 2.18.9; i486-pc-linux-gnu)
Cc: linux-geode@bombadil.infradead.org, linux-crypto@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 13:17:59 -0400
Chihau Chau <chihau@gmail.com> wrote:

> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like:
> 
> - Use #include <linux/io.h> instead of <asm/io.h> and #include
>   <linux/delay.h> instead of <asm/delay.h>
> 
> - Use "foo *bar" instead of "foo * bar"
> 
> - Add a space after the for or while sentence and before the open
>   parenthesis '('
> 
> - Don't use assignments in a if condition
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

Looks obviously correct to me.

Acked-by: Andres Salomon <dilinger@debian.org>


> ---
>  drivers/crypto/geode-aes.c |   36 ++++++++++++++++++++----------------
>  1 files changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
> index c7a5a43..09389dd 100644
> --- a/drivers/crypto/geode-aes.c
> +++ b/drivers/crypto/geode-aes.c
> @@ -15,14 +15,14 @@
>  #include <crypto/algapi.h>
>  #include <crypto/aes.h>
>  
> -#include <asm/io.h>
> -#include <asm/delay.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
>  

I don't see any delay functions being used anywhere; delay.h can
probably just be dropped.




