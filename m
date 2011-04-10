Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1DJPKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:10:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:55230 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1DJPKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:10:37 -0400
Date: Sun, 10 Apr 2011 08:10:35 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH V2 3/5]arch:m68k:asm Fix typo occcured.
In-Reply-To: <1301507703-3364-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1104081958310.6392@deuxcents.site>
References: <1301507703-3364-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Justin P. Mattock wrote:

> The patch below changes a typo occcured to occurred in two comments.
>  
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/m68k/include/asm/MC68EZ328.h |    2 +-
>  arch/m68k/include/asm/MC68VZ328.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/MC68EZ328.h b/arch/m68k/include/asm/MC68EZ328.h
> index 69b7f91..d1bde58 100644
> --- a/arch/m68k/include/asm/MC68EZ328.h
> +++ b/arch/m68k/include/asm/MC68EZ328.h
> @@ -1047,7 +1047,7 @@ typedef volatile struct {
>  
>  #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>  #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occurred */
>  #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>  #define WATCHDOG_CNT_SHIFT 8
>  
> diff --git a/arch/m68k/include/asm/MC68VZ328.h b/arch/m68k/include/asm/MC68VZ328.h
> index 2b9bf62..6bd1bf1 100644
> --- a/arch/m68k/include/asm/MC68VZ328.h
> +++ b/arch/m68k/include/asm/MC68VZ328.h
> @@ -1143,7 +1143,7 @@ typedef struct {
>  
>  #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>  #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occurred */
>  #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>  #define WATCHDOG_CNT_SHIFT 8

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

