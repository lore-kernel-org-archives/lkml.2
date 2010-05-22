Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0EVH7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 03:59:14 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:42582 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab0EVH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 03:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=NZzS4l16833L+sJfH9jBaEiX/uwi3b50gP+N3izYsUnbiy6UuVnRWSqOPr4GIC721d
         h5JGZD5Z0v6L/zKzJLfChSywnh7+Dzjh3R0Cg0wOri82oYwvhCvhjLI25CeyaYemG0/1
         ijJC0FRarXsW305tfH2/3oO9ymxuzK16mEaHk=
Date: Sat, 22 May 2010 10:58:59 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: Re: [PATCH] x86/mmiotrace: remove redundant instruction prefix
 checks
Message-ID: <20100522105859.41bc754d@daedalus.pq.iki.fi>
In-Reply-To: <1274140110-5841-1-git-send-email-akinobu.mita@gmail.com>
References: <1274140110-5841-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 08:48:30 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Get rid of the duplicated entries in prefix_codes[] to eliminate
> redundant checks by skip_prefix().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org

Acked-by: Pekka Paalanen <pq@iki.fi>

> ---
>  arch/x86/mm/pf_in.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
> index df3d5c8..308e325 100644
> --- a/arch/x86/mm/pf_in.c
> +++ b/arch/x86/mm/pf_in.c
> @@ -34,7 +34,7 @@
>  /* IA32 Manual 3, 2-1 */
>  static unsigned char prefix_codes[] = {
>  	0xF0, 0xF2, 0xF3, 0x2E, 0x36, 0x3E, 0x26, 0x64,
> -	0x65, 0x2E, 0x3E, 0x66, 0x67
> +	0x65, 0x66, 0x67
>  };
>  /* IA32 Manual 3, 3-432*/
>  static unsigned int reg_rop[] = {
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html Please read the FAQ
> at  http://www.tux.org/lkml/
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
