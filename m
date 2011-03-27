Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1C0L3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 07:29:47 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:34788 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1C0L3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 07:29:46 -0400
Message-ID: <4D8F1F89.2010700@snapgear.com>
Date: Sun, 27 Mar 2011 21:29:13 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MAINTAINERS: Update m68knommu patterns
References: <1d67762792f7d409375f5a29c2159f39164ac166.1301178998.git.joe@perches.com>
In-Reply-To: <1d67762792f7d409375f5a29c2159f39164ac166.1301178998.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/11 08:37, Joe Perches wrote:
> Commit 66d857b08b ("m68k: merge m68k and m68knommu arch directories")
> moved the files around.
>
> cc: Greg Ungerer<gerg@uclinux.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Thanks Joe!


> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   MAINTAINERS |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4fb9017..735f124 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6274,7 +6274,8 @@ M:	Greg Ungerer<gerg@uclinux.org>
>   W:	http://www.uclinux.org/
>   L:	uclinux-dev@uclinux.org  (subscribers-only)
>   S:	Maintained
> -F:	arch/m68knommu/
> +F:	arch/m68k/*/*_no.*
> +F:	arch/m68k/include/asm/*_no.*
>
>   UCLINUX FOR RENESAS H8/300 (H8300)
>   M:	Yoshinori Sato<ysato@users.sourceforge.jp>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
