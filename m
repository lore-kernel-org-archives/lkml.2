Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab0E0SBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:01:05 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:57840 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387Ab0E0SAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:00:55 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] ibft: Use IBFT_SIGN instead of open-coding the search string.
Date: Thu, 27 May 2010 13:59:59 -0400
User-Agent: KMail/1.9.10
Cc: Len Brown <lenb@kernel.org>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
       linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org
References: <4BEAB683.8040600@redhat.com> <1273674308-9366-1-git-send-email-pjones@redhat.com>
In-Reply-To: <1273674308-9366-1-git-send-email-pjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005271359.59974.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 May 2010 10:25:08 Peter Jones wrote:
> We define IBFT_SIGN to "iBFT"; may as well use it.
>

Len,

Were you OK with this patch? I was thinking to send to Linus a git-pull for 
this (and the other patches referenced in this patchset).

> Signed-off-by: Peter Jones <pjones@redhat.com>
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


