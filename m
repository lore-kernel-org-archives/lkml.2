Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423003Ab2KNOex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:34:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17390 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422661Ab2KNOew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:34:52 -0500
Date: Wed, 14 Nov 2012 17:33:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: devel@driverdev.osuosl.org, line6linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/8] staging: line6: wrap >80 char lines in capture.c
Message-ID: <20121114143305.GH11515@mwanda>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
 <1352636686-31170-2-git-send-email-stefanha@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352636686-31170-2-git-send-email-stefanha@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 01:24:39PM +0100, Stefan Hajnoczi wrote:
> Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
> ---
>  drivers/staging/line6/capture.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
> index c85c5b6..389c41f 100644
> --- a/drivers/staging/line6/capture.c
> +++ b/drivers/staging/line6/capture.c
> @@ -256,8 +256,8 @@ static void audio_in_callback(struct urb *urb)
>  #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
>  		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
>  #endif
> -			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm->flags)
> -			    && (fsize > 0))
> +			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM,

The reason this is hitting the 80 character limit is because
"LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM" is 35 characters long.  It
isn't even clear from the name what it holds.  It's just a very crap
name.

regards,
dan carpenter
