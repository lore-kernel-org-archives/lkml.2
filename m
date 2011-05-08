Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1EHSoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:44:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56087 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab1EHSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sIngrW3MWKRtlvv5Er2rRqTmqWP3oudgzc/GWm7Cvbt65H54aEMpEyb41rP45NPZvl
         l9LC8pRltNgF/XKTXxNw0CCQfCyKkzOry0SWDljTtfodLg25O+wTprRQaxxKCueEI9rM
         x5ym/QkEGdeSScL+/xEwkuZQPQowuf1UY/O2g=
Subject: Re: [PATCH] checkpatch: add __rcu as a sparse modifier
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
In-Reply-To: <1304848485-14219-1-git-send-email-sven@narfation.org>
References: <1304848485-14219-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 20:43:55 +0200
Message-ID: <1304880235.3207.46.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 08 mai 2011 à 11:54 +0200, Sven Eckelmann a écrit :
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> ---
>  scripts/checkpatch.pl |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d867081..9dc3800 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -145,7 +145,8 @@ our $Sparse	= qr{
>  			__must_check|
>  			__init_refok|
>  			__kprobes|
> -			__ref
> +			__ref|
> +			__rcu
>  		}x;
>  
>  # Notes to $Attribute:

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



