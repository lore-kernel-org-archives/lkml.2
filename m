Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1DQTDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 15:03:45 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:37130 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753499Ab1DQTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 15:03:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BPNMtpCoLxg2i77ecwf44grSZ3kll9OIOfdegfW9zgL2EBX+5UWw5A3IULnlpP/RojXmQtRdzEiOfvZfatXmK0Jd63IbV6WHdYxZ73WOO0CQd0ntcWyn0mjJhI1y5OKS;
Date: Sun, 17 Apr 2011 12:03:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5 v2]Typo: Remove one to many ccc's in some comments.
Message-Id: <20110417120336.49f71508.rdunlap@xenotime.net>
In-Reply-To: <1303063749-8282-3-git-send-email-justinmattock@gmail.com>
References: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
	<1303063749-8282-3-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011 11:09:07 -0700 Justin P. Mattock wrote:

> The below patch is a resend due to rebasing to the current Mainline, fixing
> some comments due to having one to many ccc's in the definitions.
>  
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/m68k/include/asm/MC68EZ328.h |    2 +-
>  arch/m68k/include/asm/MC68VZ328.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/MC68EZ328.h b/arch/m68k/include/asm/MC68EZ328.h
> index 69b7f91..b2ee25d 100644
> --- a/arch/m68k/include/asm/MC68EZ328.h
> +++ b/arch/m68k/include/asm/MC68EZ328.h
> @@ -1047,7 +1047,7 @@ typedef volatile struct {
>  
>  #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
>  #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
> -#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
> +#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */

                                                              occurred
(above and below)

>  #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
>  #define WATCHDOG_CNT_SHIFT 8
>  
> diff --git a/arch/m68k/include/asm/MC68VZ328.h b/arch/m68k/include/asm/MC68VZ328.h
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


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
