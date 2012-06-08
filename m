Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab2FHBfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:35:54 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:11708 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827Ab2FHBfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:35:51 -0400
Message-ID: <4FD15678.3050401@snapgear.com>
Date: Fri, 8 Jun 2012 11:33:44 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Philippe De Muyter <phdm@macqel.be>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] m68k: Remove duplicate FPU config option
References: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/12 04:47, Geert Uytterhoeven wrote:
> It's also defined in arch/m68k/Kconfig.cpu

Yep :-)


> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer<gerg@uclinux.org>

Thanks
Greg


>   arch/m68k/Kconfig |    3 ---
>   1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
> index 1471201..bc8cc50 100644
> --- a/arch/m68k/Kconfig
> +++ b/arch/m68k/Kconfig
> @@ -62,9 +62,6 @@ config CPU_HAS_NO_MULDIV64
>   config CPU_HAS_ADDRESS_SPACES
>   	bool
>
> -config FPU
> -	bool
> -
>   config HZ
>   	int
>   	default 1000 if CLEOPATRA


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
