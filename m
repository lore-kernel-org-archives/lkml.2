Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1BCRLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:11:35 -0500
Received: from service87.mimecast.com ([94.185.240.25]:54053 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755942Ab1BCRLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:11:33 -0500
Subject: Re: [PATCH v4 08/19] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1295891761-18366-9-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-9-git-send-email-catalin.marinas@arm.com>
Organization: ARM Limited
Date: Thu, 03 Feb 2011 17:11:28 +0000
Message-ID: <1296753088.28466.18.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 03 Feb 2011 17:11:30.0397 (UTC) FILETIME=[6663A0D0:01CBC3C5]
X-MC-Unique: 111020317113102701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 17:55 +0000, Catalin Marinas wrote:
> --- /dev/null
> +++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
> @@ -0,0 +1,81 @@
[...]
> +#define PMD_SECT_UNCACHED      (_AT(pteval_t, 0) << 2) /* strongly ordered */
> +#define PMD_SECT_BUFFERED      (_AT(pteval_t, 1) << 2) /* normal non-cacheable */
> +#define PMD_SECT_WT            (_AT(pteval_t, 2) << 2) /* normal inner write-through */
> +#define PMD_SECT_WB            (_AT(pteval_t, 3) << 2) /* normal inner write-back */
> +#define PMD_SECT_WBWA          (_AT(pteval_t, 7) << 2) /* normal inner write-alloc */

The above definitions should use pmdval_t rather than pteval_t (fixup
pushed to the arm-lpae branch).

-- 
Catalin


