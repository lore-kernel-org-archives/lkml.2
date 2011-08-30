Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1H3OH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:07:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65164 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1H3OHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:07:54 -0400
Date: Tue, 30 Aug 2011 17:05:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Youquan Song <youquan.song@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>, devel@linuxdriverproject.org,
        Joe Perches <joe@perches.com>, Ilya Gorskin <Revent82@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [PATCH v3 05/18] Staging: cx25821: Fix wrong brace placement in
 cx25821-cards.c
Message-ID: <20110830140532.GK3705@shale.localdomain>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
 <1314677833-4689-6-git-send-email-leonidsbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314677833-4689-6-git-send-email-leonidsbox@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 12:17:00PM +0800, Leonid V. Fedorenchik wrote:
> Fix wrong brace placement in cx25821-cards.c
> 
> Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
> ---
>  drivers/staging/cx25821/cx25821-cards.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/staging/cx25821/cx25821-cards.c
> index 94e8d68..876345a 100644
> --- a/drivers/staging/cx25821/cx25821-cards.c
> +++ b/drivers/staging/cx25821/cx25821-cards.c
> @@ -39,14 +39,14 @@ struct cx25821_board cx25821_boards[] = {
>  			   .name = "UNKNOWN/GENERIC",
>  			   /* Ensure safe default for unknown boards */
>  			   .clk_freq = 0,
                           ^^^^^^^^^^^^^
You may as well pull these in an indent level while you're at it.

> -			   },
> +	},

regards,
dan carpenter

