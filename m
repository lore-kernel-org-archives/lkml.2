Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0DZVyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:54:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53854 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157Ab0DZVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:54:48 -0400
Date: Mon, 26 Apr 2010 22:59:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, npelly@google.com,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH] serial: TTY: new ldiscs for staging
Message-ID: <20100426225957.532559a2@lxorguk.ukuu.org.uk>
In-Reply-To: <1270750619-19174-2-git-send-email-pavan_savoy@ti.com>
References: <1270750619-19174-1-git-send-email-pavan_savoy@ti.com>
	<1270750619-19174-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Apr 2010 13:16:52 -0500
pavan_savoy@ti.com wrote:

> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Push the max ldiscs by a few number to allow ldiscs
> to exist in the staging directory
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  include/linux/tty.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 4409967..227c0a8 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -23,7 +23,7 @@
>   */
>  #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
>  #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
> -#define NR_LDISCS		20
> +#define NR_LDISCS		25	/* add few ldiscs for staging */

Doesn't directly apply as NR_LDISCS is now 21 but this should definitely
go in.
