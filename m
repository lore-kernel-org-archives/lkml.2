Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0KKQCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:02:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63796 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0KKQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:02:31 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] OMAP: Serial: Define OMAP uart MDR1 register definitions
Organization: Deep Root Systems, LLC
References: <1289484812-17278-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Date: Thu, 11 Nov 2010 08:02:27 -0800
In-Reply-To: <1289484812-17278-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	(Emeltchenko Andrei's message of "Thu, 11 Nov 2010 16:13:32 +0200")
Message-ID: <87hbfnx2zw.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com> writes:

> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
>
> Define MDR1 register serial definitions used in serial and
> bluetooth drivers. Remove magic numbers there.

Remove magic numbers where?  This patch doesn't remove anything.

> *v2	added OMAP keyword

This info should go after the '---' as it is not needed in the final
git history.

Kevin

> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> ---
>  include/linux/serial_reg.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
> index c7a0ce1..6f38234 100644
> --- a/include/linux/serial_reg.h
> +++ b/include/linux/serial_reg.h
> @@ -341,5 +341,17 @@
>  #define UART_OMAP_SYSS		0x16	/* System status register */
>  #define UART_OMAP_WER		0x17	/* Wake-up enable register */
>  
> +/*
> + * These are the definitions for the MDR1 register
> + */
> +#define UART_OMAP_MDR1_16X_MODE		0x00	/* UART 16x mode */
> +#define UART_OMAP_MDR1_SIR_MODE		0x01	/* SIR mode */
> +#define UART_OMAP_MDR1_16X_ABAUD_MODE	0x02	/* UART 16x auto-baud */
> +#define UART_OMAP_MDR1_13X_MODE		0x03	/* UART 13x mode */
> +#define UART_OMAP_MDR1_MIR_MODE		0x04	/* MIR mode */
> +#define UART_OMAP_MDR1_FIR_MODE		0x05	/* FIR mode */
> +#define UART_OMAP_MDR1_CIR_MODE		0x06	/* CIR mode */
> +#define UART_OMAP_MDR1_DISABLE		0x07	/* Disable (default state) */
> +
>  #endif /* _LINUX_SERIAL_REG_H */
