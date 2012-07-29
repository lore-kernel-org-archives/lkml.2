Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2G2LQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 07:16:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40480 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2G2LQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 07:16:48 -0400
Message-ID: <50151B9C.1080407@suse.cz>
Date: Sun, 29 Jul 2012 13:16:44 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120718 Thunderbird/15.0
MIME-Version: 1.0
To: Baodong Chen <chenbdchenbd@gmail.com>
CC: gregkh@linuxfoundation.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:net:fixed to fit tty_driver's kref field
References: <1343551248-3447-1-git-send-email-chenbdchenbd@gmail.com>
In-Reply-To: <1343551248-3447-1-git-send-email-chenbdchenbd@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 10:40 AM, Baodong Chen wrote:
> Fixed code to fix tty_driver's kref field
> checkpatch.pl clean up
> Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>

NACK. Please read Documentation/SubmittingPatches first.

This is an unreviewable patch. You do too many diverse changes in one
patch. Make your changes separate.

> ---
>  drivers/staging/net/pc300_tty.c |  763 ++++++++++++++++++++-------------------
>  1 files changed, 386 insertions(+), 377 deletions(-)
> 
> diff --git a/drivers/staging/net/pc300_tty.c b/drivers/staging/net/pc300_tty.c
> index 4709f42..859f680 100644
> --- a/drivers/staging/net/pc300_tty.c
> +++ b/drivers/staging/net/pc300_tty.c
> @@ -9,7 +9,7 @@
>   *  modify it under the terms of the GNU General Public License
>   *  as published by the Free Software Foundation; either version
>   *  2 of the License, or (at your option) any later version.
> - *   
> + *
>   *  $Log: pc300_tty.c,v $
>   *  Revision 3.7  2002/03/07 14:17:09  henrique
>   *  License data fixed
...

regards,
-- 
js
suse labs
