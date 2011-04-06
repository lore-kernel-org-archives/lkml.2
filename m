Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1DFOer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:34:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37988 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab1DFOeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:34:46 -0400
Date: Wed, 6 Apr 2011 16:34:41 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v2] trivial: make comment about vs{n,cn,}printf more
 understandable
Message-ID: <20110406143441.GE13963@pengutronix.de>
References: <1290567844_20137@mail4.comsite.net>
 <1290625833-32576-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290625833-32576-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

On Wed, Nov 24, 2010 at 08:10:33PM +0100, Uwe Kleine-König wrote:
> "You probably want ... instead." sounds like a recommendation better
> not to use the v... functions.
you didn't take this patch. Did you skip it on purpose?

Best regards
Uwe

> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> this is Milton's alternative suggestion plus an added "using".
> 
> Thanks
> Uwe
> 
>  lib/vsprintf.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index c150d3d..6c46e0f 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1279,8 +1279,7 @@ qualifier:
>   * return is greater than or equal to @size, the resulting
>   * string is truncated.
>   *
> - * Call this function if you are already dealing with a va_list.
> - * You probably want snprintf() instead.
> + * If you're not already dealing with a va_list consider using snprintf().
>   */
>  int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  {
> @@ -1454,8 +1453,7 @@ EXPORT_SYMBOL(vsnprintf);
>   * the @buf not including the trailing '\0'. If @size is <= 0 the function
>   * returns 0.
>   *
> - * Call this function if you are already dealing with a va_list.
> - * You probably want scnprintf() instead.
> + * If you're not already dealing with a va_list consider using scnprintf().
>   *
>   * See the vsnprintf() documentation for format string extensions over C99.
>   */
> @@ -1534,8 +1532,7 @@ EXPORT_SYMBOL(scnprintf);
>   * into @buf. Use vsnprintf() or vscnprintf() in order to avoid
>   * buffer overflows.
>   *
> - * Call this function if you are already dealing with a va_list.
> - * You probably want sprintf() instead.
> + * If you're not already dealing with a va_list consider using sprintf().
>   *
>   * See the vsnprintf() documentation for format string extensions over C99.
>   */
> -- 
> 1.7.2.3
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
