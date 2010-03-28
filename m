Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0C1UFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:05:35 -0400
Received: from mail.perches.com ([173.55.12.10]:1181 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab0C1UFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:05:33 -0400
Subject: Re: [PATCH 2/2] Staging: line6: fixed 80 character coding style
 issue in midibuf.c This is a patch to the midibuf.c file that fixes up an
 80 character error thrown by the checkpatch.pl tool Signed-off-by: Johan
 Meiring <johanmeiring@gmail.com>
From: Joe Perches <joe@perches.com>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1269804998-7169-1-git-send-email-johanmeiring@gmail.com>
References: <1269804998-7169-1-git-send-email-johanmeiring@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Mar 2010 13:05:31 -0700
Message-ID: <1269806731.1500.60.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-28 at 21:36 +0200, Johan Meiring wrote:
> ---
>  drivers/staging/line6/midibuf.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/line6/midibuf.c b/drivers/staging/line6/midibuf.c
> index ab0a5f3..fb2658d 100644
> --- a/drivers/staging/line6/midibuf.c
> +++ b/drivers/staging/line6/midibuf.c
> @@ -76,7 +76,8 @@ int midibuf_bytes_free(struct MidiBuffer *this)
>  	return
>  		midibuf_is_full(this) ?
>  		0 :
> -		(this->pos_read - this->pos_write + this->size - 1) % this->size + 1;
> +		(this->pos_read - this->pos_write + this->size - 1) % \
> +			this->size + 1;

It's not necessary to use line continuations like this.

this is an unfortunate variable name, it might be better
to rename it to mb or something.

The "(write - read + size) % size + 1" might be used a
couple of times.  Maybe use a macro or function?


