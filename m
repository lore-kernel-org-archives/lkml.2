Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0KOGhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:37:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0KOGhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:37:45 -0500
Message-ID: <4CE0D533.1010407@monstr.eu>
Date: Mon, 15 Nov 2010 07:37:39 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/44] arch/microblaze: Remove unnecessary semicolons
References: <cover.1289789604.git.joe@perches.com> <5d57b90b488b4338bcdc3f0fbf5f6996842bd44d.1289789604.git.joe@perches.com>
In-Reply-To: <5d57b90b488b4338bcdc3f0fbf5f6996842bd44d.1289789604.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/microblaze/lib/memmove.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied.

Thanks,
Michal

> 
> diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
> index 123e361..810fd68 100644
> --- a/arch/microblaze/lib/memmove.c
> +++ b/arch/microblaze/lib/memmove.c
> @@ -182,7 +182,7 @@ void *memmove(void *v_dst, const void *v_src, __kernel_size_t c)
>  			for (; c >= 4; c -= 4) {
>  				value = *--i_src;
>  				*--i_dst = buf_hold | ((value & 0xFF000000)>> 24);
> -				buf_hold = (value & 0xFFFFFF) << 8;;
> +				buf_hold = (value & 0xFFFFFF) << 8;
>  			}
>  #endif
>  			/* Realign the source */


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
