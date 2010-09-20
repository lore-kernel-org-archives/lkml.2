Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0ITB7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 21:59:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49589 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab0ITB7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 21:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=YeOp4bNWZAvaU/hdS0mR/StMChSK1mcEY2Kn52uFJ3pp+lczX9sBDECIs2EchdbaNH
         4Ddw5lMLzHlKOrNtGKVpAQF3iHKH803hPqPX4ZEDH6ogNEQAVsw3ORbvk0gEmO+LKY/e
         ocTmeFKdIjeYflXNLW+tNpV+uMSf3+XeeszNA=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/6] MAINTAINERS: Fix Colibri PXA270 file pattern
Date: Mon, 20 Sep 2010 03:59:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <cover.1284937055.git.joe@perches.com> <53d7035ee03a9d1e9615df8b883349af083d280b.1284937055.git.joe@perches.com>
In-Reply-To: <53d7035ee03a9d1e9615df8b883349af083d280b.1284937055.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009200359.40467.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 20. září 2010 01:10:29 Joe Perches napsal(a):
> The original commit 403d29713e0a5c671d852913a0b5935c0ff00cb7 started
> with the wrong file pattern.
> 
> CC: Marek Vasut <marek.vasut@gmail.com>

Good catch, thanks!
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4c14636..a9f0567 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -708,8 +708,7 @@ ARM/INCOME PXA270 SUPPORT
>  M:	Marek Vasut <marek.vasut@gmail.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
> -F:	arch/arm/mach-pxa/income.c
> -F:	arch/arm/mach-pxa/include/mach-pxa/income.h
> +F:	arch/arm/mach-pxa/colibri-pxa270-income.c
> 
>  ARM/INTEL IOP32X ARM ARCHITECTURE
>  M:	Lennert Buytenhek <kernel@wantstofly.org>
