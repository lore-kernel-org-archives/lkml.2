Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1C3Rox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:44:53 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:40626 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754910Ab1C3Row (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:44:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance:X-Identified-User;
	b=J4YnFqpXWoypGEIpcIEDGEVnoAxFRF1VrPMvVm3MCFy23+tHT49vQBPlQ87G9iRVvphqx4fd6E2ZvX+e25q+yvW4FENB+/sXc0OZwOpyktJDHqXRZEk4Z5rIb3knOrbO;
Message-ID: <a69599be848c8abb3e136823ad788bfc.squirrel@xenotime.net>
In-Reply-To: <1301504478-3450-3-git-send-email-justinmattock@gmail.com>
References: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
    <1301504478-3450-3-git-send-email-justinmattock@gmail.com>
Date: Wed, 30 Mar 2011 10:44:51 -0700
Subject: Re: [PATCH 3/5]arch:m68k:asm Remove one to many ccc's.
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, March 30, 2011 10:01 am, Justin P. Mattock wrote:
> The patch below removes one to many ccc's in some comments.

The patch also needs to add an 'r':  "occurred"


> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  arch/m68k/include/asm/MC68EZ328.h |    2 +-
>  arch/m68k/include/asm/MC68VZ328.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/m68k/include/asm/MC68EZ328.h
> b/arch/m68k/include/asm/MC68EZ328.h
> index 69b7f91..b2ee25d 100644
> --- a/arch/m68k/include/asm/MC68EZ328.h
> +++ b/arch/m68k/include/asm/MC68EZ328.h
> @@ -1047,7 +1047,7 @@ typedef volatile struct {
>
>  #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>  #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */
>  #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>  #define WATCHDOG_CNT_SHIFT 8
>
> diff --git a/arch/m68k/include/asm/MC68VZ328.h
> b/arch/m68k/include/asm/MC68VZ328.h
> index 2b9bf62..62cd79a 100644
> --- a/arch/m68k/include/asm/MC68VZ328.h
> +++ b/arch/m68k/include/asm/MC68VZ328.h
> @@ -1143,7 +1143,7 @@ typedef struct {
>
>  #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>  #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */
>  #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>  #define WATCHDOG_CNT_SHIFT 8
>
> --


-- 
~Randy

