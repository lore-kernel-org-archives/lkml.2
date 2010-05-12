Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0ELOgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:36:25 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:39496 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0ELOgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:36:24 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] ibft: Use IBFT_SIGN instead of open-coding the search string.
Date: Wed, 12 May 2010 10:35:32 -0400
User-Agent: KMail/1.9.10
Cc: Len Brown <lenb@kernel.org>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
       linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <4BEAB683.8040600@redhat.com> <1273674308-9366-1-git-send-email-pjones@redhat.com>
In-Reply-To: <1273674308-9366-1-git-send-email-pjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005121035.33199.konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Please also consider this patch with the others I've sent.
I've put this (and the other ones) on:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git dev.ibft

On Wednesday 12 May 2010 10:25:08 Peter Jones wrote:
> We define IBFT_SIGN to "iBFT"; may as well use it.
>
> Signed-off-by: Peter Jones <pjones@redhat.com>

Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>

> ---
>  drivers/firmware/iscsi_ibft_find.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/firmware/iscsi_ibft_find.c
> b/drivers/firmware/iscsi_ibft_find.c index 82a7a15..2192456 100644
> --- a/drivers/firmware/iscsi_ibft_find.c
> +++ b/drivers/firmware/iscsi_ibft_find.c
> @@ -100,7 +100,7 @@ unsigned long __init find_ibft_region(unsigned long
> *sizep) if (!ibft_addr)
>  		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
>  	if (!ibft_addr)
> -		acpi_table_parse("iBFT", acpi_find_ibft);
> +		acpi_table_parse(IBFT_SIGN, acpi_find_ibft);
>  #endif /* CONFIG_ACPI */
>
>  	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will


