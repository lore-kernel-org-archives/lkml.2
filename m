Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab0FITrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:47:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46740 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab0FITro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=qr4nJNJgE+22bqMkH9bqp7RRHOFRlwVxkpMdT/vAjJtv7CEhiUGIMderv5VQPPrvs3
         HhEdHFouV68E3aGNBzBC/gpzwQVquPhIOEwRr87WYJaFxUBhkqPWk/fgH0Ctrieia52Z
         cm4Z+SVTlMACnzdqY1WnFG7VP/pzYGiPzw2n0=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 03/12] MAINTAINERS: Update ARM/VOIPAC PXA270 file patterns
Date: Wed, 9 Jun 2010 21:45:47 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <cover.1276112117.git.joe@perches.com> <b37a125e2205a491313b7ed3dff4bfdaad6a86fe.1276112117.git.joe@perches.com>
In-Reply-To: <b37a125e2205a491313b7ed3dff4bfdaad6a86fe.1276112117.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006092145.47886.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 9. června 2010 21:38:29 Joe Perches napsal(a):
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9046e97..eaffcbe 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1008,7 +1008,7 @@ M:	Marek Vasut <marek.vasut@gmail.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	arch/arm/mach-pxa/vpac270.c
> -F:	arch/arm/mach-pxa/include/mach-pxa/vpac270.h
> +F:	arch/arm/mach-pxa/include/mach/vpac270.h
> 
>  ARM/ZIPIT Z2 SUPPORT
>  M:	Marek Vasut <marek.vasut@gmail.com>

Obviously

Acked-by: Marek Vasut <marek.vasut@gmail.com>

Thanks !
