Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1LIOVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:21:41 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:26415
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab1LIOVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:21:39 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVXX7X-01-66C-02
X-M-MSG: 
Date: Fri, 9 Dec 2011 15:21:32 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH v3.2 02/10] MAINTAINERS: Update amd-iommu F: patterns
Message-ID: <20111209142132.GG3952@amd.com>
References: <cover.1323401278.git.joe@perches.com>
 <381c92e63d0d3a7bcc1966308cd9ead92199dc1b.1323401278.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <381c92e63d0d3a7bcc1966308cd9ead92199dc1b.1323401278.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 08:21:40PM -0800, Joe Perches wrote:
> Commit 29b68415e335 ("x86: amd_iommu: move to drivers/iommu/")
> moved the files, update the patterns.
> 
> CC: Ohad Ben-Cohen <ohad@wizery.com>
> CC: Joerg Roedel <joerg.roedel@amd.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7daf771..80167e7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -511,8 +511,8 @@ M:	Joerg Roedel <joerg.roedel@amd.com>
>  L:	iommu@lists.linux-foundation.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
>  S:	Supported
> -F:	arch/x86/kernel/amd_iommu*.c
> -F:	arch/x86/include/asm/amd_iommu*.h
> +F:	drivers/iommu/amd_iommu*.[ch]
> +F:	include/linux/amd-iommu.h
>  
>  AMD MICROCODE UPDATE SUPPORT
>  M:	Andreas Herrmann <andreas.herrmann3@amd.com>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

