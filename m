Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2LIPTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:19:15 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63022 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2LIPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:19:14 -0500
Date: Sun, 9 Dec 2012 15:19:09 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Steve Underwood <steveu@coppice.org>, David Rowe <david@rowetel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesper Juhl <jj@chaosbits.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: echo: remove unused variable
Message-ID: <20121209151909.GC25293@gmail.com>
References: <1354584111-1513-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354584111-1513-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping!

- cong

On Tue, Dec 04, 2012 at 01:21:44AM +0000, Cong Ding wrote:
> the variable j isn't used in the loop
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/staging/echo/echo.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
> index ca87ce9..14dfd91 100644
> --- a/drivers/staging/echo/echo.c
> +++ b/drivers/staging/echo/echo.c
> @@ -119,7 +119,6 @@
>  static inline void lms_adapt_bg(struct oslec_state *ec, int clean, int shift)
>  {
>  	int i;
> -	int j;
>  	int offset1;
>  	int offset2;
>  	int factor;
> @@ -142,7 +141,7 @@ static inline void lms_adapt_bg(struct oslec_state *ec, int clean, int shift)
>  
>  	/* asm("st:"); */
>  	n = ec->taps;
> -	for (i = 0, j = offset2; i < n; i++, j++) {
> +	for (i = 0; i < n; i++) {
>  		exp = *phist++ * factor;
>  		ec->fir_taps16[1][i] += (int16_t) ((exp + (1 << 14)) >> 15);
>  	}
> -- 
> 1.7.4.5
> 
