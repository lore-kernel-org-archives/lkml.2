Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab1FWX7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:59:19 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25918 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805Ab1FWX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:59:17 -0400
Date: Fri, 24 Jun 2011 01:50:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Rientjes <rientjes@google.com>
cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] acpi: remove NID_INVAL
In-Reply-To: <alpine.DEB.2.00.1106211756110.4454@chino.kir.corp.google.com>
Message-ID: <alpine.LNX.2.00.1106240149150.17688@swampdragon.chaosbits.net>
References: <alpine.DEB.2.00.1106211756110.4454@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011, David Rientjes wrote:

> b552a8c56db8 ("ACPI: remove NID_INVAL") removed the left over uses of
> NID_INVAL, but didn't actually remove the definition.  Remove it.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/acpi.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -238,7 +238,6 @@ extern int acpi_paddr_to_node(u64 start_addr, u64 size);
>  extern int pnpacpi_disabled;
>  
>  #define PXM_INVAL	(-1)
> -#define NID_INVAL	(-1)
>  
>  int acpi_check_resource_conflict(const struct resource *res);
>  
Yup. I agree. All that's left is that define and it should just die.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

