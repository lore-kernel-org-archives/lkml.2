Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1FJGwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:52:08 -0400
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:1264 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1FJGwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:52:04 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jun 2011 02:52:04 EDT
Message-ID: <4DF1BDB4.20602@ixiacom.com>
Date: Fri, 10 Jun 2011 09:46:12 +0300
From: Daniel Baluta <dbaluta@ixiacom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Maxin B John <maxin.john@gmail.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: update kmemleak architecture support info
References: <20110609185957.GA3250@maxin>
In-Reply-To: <20110609185957.GA3250@maxin>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 09:59 PM, Maxin B John wrote:
> Kmemleak now supports s390 and mips too.
>
> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
> ---
> diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
> index 090e6ee..82833ff 100644
> --- a/Documentation/kmemleak.txt
> +++ b/Documentation/kmemleak.txt
> @@ -11,7 +11,8 @@ with the difference that the orphan objects are not freed but only
>   reported via /sys/kernel/debug/kmemleak. A similar method is used by the
>   Valgrind tool (memcheck --leak-check) to detect the memory leaks in
>   user-space applications.
> -Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
> +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, tile,
> +s390 and mips.
>
>   Usage
>   -----
Hello,

I am fine with this. What do you say about having
something generic like:

"Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug
for supported platforms"

In this way, there's no need to update kememleak.txt everytime
when a new platform is supported.


thanks,
Daniel.
