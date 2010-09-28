Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0I1Glb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:41:31 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:17661 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752048Ab0I1Gl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:41:29 -0400
Message-ID: <4CA18E00.7090207@snapgear.com>
Date: Tue, 28 Sep 2010 16:41:04 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: matt mooney <mfm@muteddisk.com>
CC: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 08/20] m68knommu: change to new flag variables
References: <1285224645-29728-1-git-send-email-mfm@muteddisk.com>
In-Reply-To: <1285224645-29728-1-git-send-email-mfm@muteddisk.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2010 06:41:23.0668 (UTC) FILETIME=[2AF29940:01CB5ED8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Matt,

On 23/09/10 16:50, matt mooney wrote:
> Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.
>
> Signed-off-by: matt mooney<mfm@muteddisk.com>

Looks fine to me. Are you looking for this to go through
maintainer trees, or the whole patch series in one go?

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


> ---
>   arch/m68knommu/platform/5206/Makefile     |    4 ++--
>   arch/m68knommu/platform/5206e/Makefile    |    4 ++--
>   arch/m68knommu/platform/520x/Makefile     |    4 ++--
>   arch/m68knommu/platform/523x/Makefile     |    4 ++--
>   arch/m68knommu/platform/5249/Makefile     |    4 ++--
>   arch/m68knommu/platform/5272/Makefile     |    4 ++--
>   arch/m68knommu/platform/527x/Makefile     |    4 ++--
>   arch/m68knommu/platform/528x/Makefile     |    4 ++--
>   arch/m68knommu/platform/5307/Makefile     |    4 ++--
>   arch/m68knommu/platform/532x/Makefile     |    4 ++--
>   arch/m68knommu/platform/5407/Makefile     |    4 ++--
>   arch/m68knommu/platform/coldfire/Makefile |    4 ++--
>   12 files changed, 24 insertions(+), 24 deletions(-)
>
> diff --git a/arch/m68knommu/platform/5206/Makefile b/arch/m68knommu/platform/5206/Makefile
> index 113c333..b5db056 100644
> --- a/arch/m68knommu/platform/5206/Makefile
> +++ b/arch/m68knommu/platform/5206/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/5206e/Makefile b/arch/m68knommu/platform/5206e/Makefile
> index 113c333..b5db056 100644
> --- a/arch/m68knommu/platform/5206e/Makefile
> +++ b/arch/m68knommu/platform/5206e/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/520x/Makefile b/arch/m68knommu/platform/520x/Makefile
> index 435ab34..ad3f4e5 100644
> --- a/arch/m68knommu/platform/520x/Makefile
> +++ b/arch/m68knommu/platform/520x/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/523x/Makefile b/arch/m68knommu/platform/523x/Makefile
> index b8f9b45..c04b8f7 100644
> --- a/arch/m68knommu/platform/523x/Makefile
> +++ b/arch/m68knommu/platform/523x/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/5249/Makefile b/arch/m68knommu/platform/5249/Makefile
> index f56225d..4bed30f 100644
> --- a/arch/m68knommu/platform/5249/Makefile
> +++ b/arch/m68knommu/platform/5249/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/5272/Makefile b/arch/m68knommu/platform/5272/Makefile
> index 93673ef..34110fc 100644
> --- a/arch/m68knommu/platform/5272/Makefile
> +++ b/arch/m68knommu/platform/5272/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/527x/Makefile b/arch/m68knommu/platform/527x/Makefile
> index 3d90e6d..6ac4b57 100644
> --- a/arch/m68knommu/platform/527x/Makefile
> +++ b/arch/m68knommu/platform/527x/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/528x/Makefile b/arch/m68knommu/platform/528x/Makefile
> index 3d90e6d..6ac4b57 100644
> --- a/arch/m68knommu/platform/528x/Makefile
> +++ b/arch/m68knommu/platform/528x/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs.  You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/5307/Makefile b/arch/m68knommu/platform/5307/Makefile
> index 6de5269..d4293b7 100644
> --- a/arch/m68knommu/platform/5307/Makefile
> +++ b/arch/m68knommu/platform/5307/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs. You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/532x/Makefile b/arch/m68knommu/platform/532x/Makefile
> index 4cc2324..ce01669 100644
> --- a/arch/m68knommu/platform/532x/Makefile
> +++ b/arch/m68knommu/platform/532x/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs. You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/5407/Makefile b/arch/m68knommu/platform/5407/Makefile
> index dee62c5..e83fe14 100644
> --- a/arch/m68knommu/platform/5407/Makefile
> +++ b/arch/m68knommu/platform/5407/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs. You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
> diff --git a/arch/m68knommu/platform/coldfire/Makefile b/arch/m68knommu/platform/coldfire/Makefile
> index f72a0e5..788c13f 100644
> --- a/arch/m68knommu/platform/coldfire/Makefile
> +++ b/arch/m68knommu/platform/coldfire/Makefile
> @@ -8,8 +8,8 @@
>   # on the console port whenever a DBG interrupt occurs. You have to
>   # set up you HW breakpoints to trigger a DBG interrupt:
>   #
> -# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
> -# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
> +# ccflags-y := -DTRAP_DBG_INTERRUPT
> +# asflags-y := -DTRAP_DBG_INTERRUPT
>   #
>
>   asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1

