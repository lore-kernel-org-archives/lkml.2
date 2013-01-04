Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3ADPyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:54:03 -0500
Received: from mga05.intel.com ([192.55.52.89]:19874 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754966Ab3ADPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:54:01 -0500
Message-ID: <1357314835.8203.27.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [RFC,1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
From: Matt Fleming <matt.fleming@intel.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 04 Jan 2013 15:53:55 +0000
In-Reply-To: <CA+icZUWcAuwp4dPStfdgcnZdjhBkEgK54ogGzptfsoL_O5rRxw@mail.gmail.com>
References: <CA+icZUWcAuwp4dPStfdgcnZdjhBkEgK54ogGzptfsoL_O5rRxw@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 19:35 +0100, Sedat Dilek wrote:
> [ include/linux/efi.h ]
> ...
> + * We play games with efi_enabled so that the compiler will, if
> + * possible, remove EFI-related code altogether.
>   */
> +#define EFI_BOOT		0x00000001 /* Were we booted from EFI? */
> +#define EFI_SYSTEM_TABLES	0x00000002 /* Can we use EFI system tables? */
> +#define EFI_CONFIG_TABLES	0x00000004 /* Can we use EFI config tables? */
> +#define EFI_RUNTIME_SERVICES	0x00000004 /* Can we use runtime services? */
> +#define EFI_MEMMAP		0x00000008 /* Can we use EFI memory map? */
> +#define EFI_64BIT		0x00000010 /* Is the firmware 64-bit? */
> +
> ...
> 
> 2x 0x00000004? Typo or intended?

Heh, that would be a typo. Thanks for pointing that out.

