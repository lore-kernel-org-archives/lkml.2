Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2KGOHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:07:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2KGOHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:07:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 31/31] ARC: [plat-arcfpga] defconfig
Date: Wed, 7 Nov 2012 14:06:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-32-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352281674-2186-32-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211071406.58304.arnd@arndb.de>
X-Provags-ID: V02:K0:DZEZCRHmqANjYCEs7oJbNvKpJQ7KqgRqUiGLkbeYInp
 0sLAZrL72Plp18+D0Rnun9x9I0k7E8WPWYmpvuztEfyi9D4z9N
 U5tyvIdorvQHwARnOkDvF75jelMwtKiQTIY/LtF3BVxijktwt8
 a2TqjYHjDER2UfD/NU9hxTujKlDRvy024K5PLYGGi5nWkGoGGe
 UFnirWyu+ISpdLecPVYH6AXxRSBM0IG7K5sji6AIEDx7hu+TWs
 wDLFMpwY+DzCTkdLS9gj3dLCsivtL/ruk0PbZ7NLc/Q3H7oRwN
 9KuA99puofJbCaBLdF7S7D+nGKrng7CSbzHGajRxVFz3AMVKVC
 Toh/bpt1EHRELlwOuG5s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012, Vineet Gupta wrote:
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/configs/fpga_defconfig |  607 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 607 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arc/configs/fpga_defconfig
> 
> diff --git a/arch/arc/configs/fpga_defconfig b/arch/arc/configs/fpga_defconfig
> new file mode 100644
> index 0000000..cfdca3c
> --- /dev/null
> +++ b/arch/arc/configs/fpga_defconfig
> @@ -0,0 +1,607 @@
> +#
> +# Automatically generated file; DO NOT EDIT.
> +# Linux/arc 3.7.0-rc3 Kernel Configuration
> +#

Please use "make defconfig" to generate minimal defconfig files, instead of
copying the entire file here.

	Arnd
