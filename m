Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0EJVdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:33:06 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:53104 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0EJVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:33:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dNXLr+3uqAaMStYy6B2P/YJJulz/jZg7mADQDjJCqARBsXPkMs6CUqIadW4Mso/cdl
         GgKXTaPYA+caIoddlm42J4flue6SSdXcr4KuKMcQFwsDeO7Uv65fEFUGOgC3rvI7eCbr
         mOJmWxX8ATYO+0APqFJn33BaJACdoim1UB43o=
Message-ID: <4BE87B8A.9050006@gmail.com>
Date: Tue, 11 May 2010 00:32:58 +0300
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk
Subject: Re: [PATCH 4/4] MAINTAINERS: update for ARM/Gemini
References: <1273522021-14436-1-git-send-email-ulli.kroll@googlemail.com> <1273522021-14436-5-git-send-email-ulli.kroll@googlemail.com>
In-Reply-To: <1273522021-14436-5-git-send-email-ulli.kroll@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 11:07 PM, Hans Ulli Kroll wrote:
> Signed-off-by: Hans Ulli Kroll<ulli.kroll@googlemail.com>

Acked-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>

> ---
>   MAINTAINERS |   11 ++++++-----
>   1 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 449d444..8a0fe7f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -620,10 +620,10 @@ M:	Richard Purdie<rpurdie@rpsys.net>
>   S:	Maintained
>
>   ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
> -M:	Paulius Zaleckas<paulius.zaleckas@gmail.com>
> +M:	Hans Ulli Kroll<ulli.kroll@googlemail.com>
>   L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -T:	git git://gitorious.org/linux-gemini/mainline.git
> -S:	Odd Fixes
> +T:	git git://git.berlios.de/gemini-board
> +S:	Maintained
>   F:	arch/arm/mach-gemini/
>
>   ARM/EBSA110 MACHINE SUPPORT
> @@ -645,9 +645,10 @@ T:	topgit git://git.openezx.org/openezx.git
>   F:	arch/arm/mach-pxa/ezx.c
>
>   ARM/FARADAY FA526 PORT
> -M:	Paulius Zaleckas<paulius.zaleckas@gmail.com>
> +M:	Hans Ulli Kroll<ulli.kroll@googlemail.com>
>   L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -S:	Odd Fixes
> +S:	Maintained
> +T:	git://git.berlios.de/gemini-board
>   F:	arch/arm/mm/*-fa*
>
>   ARM/FOOTBRIDGE ARCHITECTURE

