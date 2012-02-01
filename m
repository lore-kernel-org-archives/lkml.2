Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2BAJkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:40:14 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49667 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2BAJkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:40:11 -0500
Message-ID: <4F290877.8050406@gmail.com>
Date: Wed, 01 Feb 2012 10:40:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 3/5] TTY: use tty_standard_install
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz> <1327954472-26594-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1327954472-26594-3-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 09:14 PM, Jiri Slaby wrote:
> Use the helper in the rest of the tty drivers. This is a simple
> replacement.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/isdn/capi/capi.c     |    9 +++------
>  drivers/misc/pti.c           |    6 +-----
>  drivers/mmc/card/sdio_uart.c |    9 +++------
>  drivers/tty/nozomi.c         |    8 ++------
>  4 files changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
> index e44933d..ca9261a 100644
> --- a/drivers/isdn/capi/capi.c
> +++ b/drivers/isdn/capi/capi.c
> @@ -1015,14 +1015,11 @@ capinc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
>  {
>  	int idx = tty->index;
>  	struct capiminor *mp = capiminor_get(idx);
> -	int ret = tty_init_termios(tty);
> +	int ret = tty_standard_install(tty);

Uh, what version of the patch did I send? tty_standard_install takes 2
arguments! I will post the correct one in a moment.

sorry,
-- 
js
