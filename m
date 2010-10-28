Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0J1CBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 22:01:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:14479 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab0J1CBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 22:01:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,248,1286175600"; 
   d="scan'208";a="341408244"
From: "Wang, Shane" <shane.wang@intel.com>
To: Joe Perches <joe@perches.com>, "Cihula, Joseph" <joseph.cihula@intel.com>
CC: x86 <x86@kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 28 Oct 2010 10:00:35 +0800
Subject: RE: [PATCH] arch/x86/kernel/tboot.c: Standardize pr_fmt
Thread-Topic: [PATCH] arch/x86/kernel/tboot.c: Standardize pr_fmt
Thread-Index: ActwhAc+XMuEabjKTv6PXrnYXvrV0AFv82fg
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A3003EBC4@shsmsx501.ccr.corp.intel.com>
References: <1287599057.1813.229.camel@Joe-Laptop>
In-Reply-To: <1287599057.1813.229.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Shane

Joe Perches wrote:
> Move the define before any #include and use the more
> standard KBUILD_MODNAME.  No change in output.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/tboot.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index c2f1b26..b9a0077 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -19,6 +19,8 @@
>   *
>   */
> 
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/dma_remapping.h>
>  #include <linux/init_task.h>
>  #include <linux/spinlock.h>
> @@ -51,9 +53,6 @@ EXPORT_SYMBOL(tboot);
>  /* timeout for APs (in secs) to enter wait-for-SIPI state during
>  shutdown */ #define AP_WAIT_TIMEOUT		1
> 
> -#undef pr_fmt
> -#define pr_fmt(fmt)	"tboot: " fmt
> -
>  static u8 tboot_uuid[16] __initdata = TBOOT_UUID;
> 
>  void __init tboot_probe(void)

