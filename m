Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab1LFORj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:17:39 -0500
Received: from 8bytes.org ([88.198.83.132]:51905 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933284Ab1LFORh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:17:37 -0500
Date: Tue, 6 Dec 2011 15:17:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] amd_iommu: Fix typo in kernel-parameters.txt
Message-ID: <20111206141735.GN20535@8bytes.org>
References: <1323122912-14532-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323122912-14532-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 11:08:32PM +0100, Sedat Dilek wrote:
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
>  Documentation/kernel-parameters.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index a0c5c5f..da50377 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -320,7 +320,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			on: enable for both 32- and 64-bit processes
>  			off: disable for both 32- and 64-bit processes
>  
> -	amd_iommu=	[HW,X86-84]
> +	amd_iommu=	[HW,X86-64]
>  			Pass parameters to the AMD IOMMU driver in the system.
>  			Possible values are:
>  			fullflush - enable flushing of IO/TLB entries when

Applied, thanks. Please Cc me directly on future patches so it is easier
to notice for me :)
