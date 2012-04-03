Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2DCLrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:47:11 -0400
Received: from ra.se.axis.com ([195.60.68.13]:34635 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab2DCLrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:47:09 -0400
Date: Tue, 3 Apr 2012 13:47:05 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jirislaby@gmail.com" <jirislaby@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 02/69] TTY: crisv10, initialize tty_port
Message-ID: <20120403114705.GR21889@axis.com>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz> <1333367693-3244-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333367693-3244-3-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 01:53:46PM +0200, Jiri Slaby wrote:
> The tty_port used in the driver is left uninitialized. Add the
> initialization there.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Mikael Starvik <starvik@axis.com>

Looks good!

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: linux-cris-kernel@axis.com
> ---
>  drivers/tty/serial/crisv10.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
> index 004ee2e..80b6b1b 100644
> --- a/drivers/tty/serial/crisv10.c
> +++ b/drivers/tty/serial/crisv10.c
> @@ -4462,6 +4462,7 @@ static int __init rs_init(void)
>  				info->enabled = 0;
>  			}
>  		}
> +		tty_port_init(&info->port);
>  		info->uses_dma_in = 0;
>  		info->uses_dma_out = 0;
>  		info->line = i;
> -- 
> 1.7.9.2
> 
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
