Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab0ELF11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:27:27 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:61409 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0ELF10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:27:26 -0400
Date: Wed, 12 May 2010 01:26:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org,
       Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 1/2] ibft: Update iBFT handling for v1.03 of the spec.
In-reply-to: <1270822888-13192-2-git-send-email-konrad@kernel.org>
Message-id: <alpine.LFD.2.00.1005120125170.5297@localhost.localdomain>
References: <1270822888-13192-1-git-send-email-konrad@kernel.org>
 <1270822888-13192-2-git-send-email-konrad@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  #define IBFT_SIGN "iBFT"
...
> +#ifdef CONFIG_ACPI
> +	/*
> +	 * One spec says "IBFT", the other says "iBFT". We have to check
> +	 * for both.
> +	 */

Really?
Which one do you see in the field?
any reason to #define "iBFT" above and not use it below?

> +	if (!ibft_addr)
> +		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
> +	if (!ibft_addr)
> +		acpi_table_parse("iBFT", acpi_find_ibft);
> +#endif /* CONFIG_ACPI */

Len Brown, Intel Open Source Technology Center
