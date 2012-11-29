Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2K2IXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:23:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49800 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2K2IXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:23:09 -0500
Message-ID: <50B71B68.2090601@suse.cz>
Date: Thu, 29 Nov 2012 09:23:04 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Chen Gang <gang.chen@asianux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: TTY - Add linux-serial mailing list
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com>  <50B6F967.3050000@asianux.com> <1354169679.29762.28.camel@joe-AO722>
In-Reply-To: <1354169679.29762.28.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 07:14 AM, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index afc0b27..255dafb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7658,6 +7658,7 @@ K:	^Subject:.*(?i)trivial
>  TTY LAYER
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  M:	Jiri Slaby <jslaby@suse.cz>
> +L:	linux-serial@vger.kernel.org

This might have the effect that people will try to reach us at that
list. But this is not true at least for me. serial != tty.

thanks,
-- 
js
suse labs
