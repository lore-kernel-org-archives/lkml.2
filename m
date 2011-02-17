Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1BQQkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:40:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab1BQQkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:40:00 -0500
Date: Thu, 17 Feb 2011 17:39:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: {PATCH][trivial] serial, pch uart: Remove duplicate inclusion
 of linux/pci.h header
In-Reply-To: <alpine.LNX.2.00.1102142343550.4530@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1102171739430.2160@pobox.suse.cz>
References: <alpine.LNX.2.00.1102142343550.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Jesper Juhl wrote:

> Only include linux/pci.h once in drivers/tty/serial/pch_uart.c
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  pch_uart.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index 3b2fb93..14a27c3 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -15,7 +15,6 @@
>   *Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
>   */
>  #include <linux/serial_reg.h>
> -#include <linux/pci.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/serial_core.h>

As it's not present in linux-next as of today, I have picked it up, 
thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
