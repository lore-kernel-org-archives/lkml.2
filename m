Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab0EMKkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:40:35 -0400
Received: from mail.perches.com ([173.55.12.10]:2212 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135Ab0EMKkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:40:33 -0400
Subject: Re: [PATCH 2/2] Staging: comedi: Fixed more long line lengths in
 comedi.h
From: Joe Perches <joe@perches.com>
To: Mark <reodge@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Bernd Porr <berndporr@f2s.com>, Gorskin Ilya <revent82@gmail.com>
In-Reply-To: <1273746519-4590-2-git-send-email-reodge@gmail.com>
References: <1273746519-4590-1-git-send-email-reodge@gmail.com>
	 <1273746519-4590-2-git-send-email-reodge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 03:40:32 -0700
Message-ID: <1273747232.21514.22.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 18:28 +0800, Mark wrote:
> I'd like to get some feedback on this patch, since I'm not sure this is the best
> way to fix the long line lengths. 
> ---
>  drivers/staging/comedi/comedi.h |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
> index 3e3663f..ea96a83 100644
> --- a/drivers/staging/comedi/comedi.h
> +++ b/drivers/staging/comedi/comedi.h
> @@ -267,7 +267,8 @@
>  		 * streaming input/output */
>  		INSN_CONFIG_GET_HARDWARE_BUFFER_SIZE = 2006,
>  		INSN_CONFIG_SET_COUNTER_MODE = 4097,
> -		INSN_CONFIG_8254_SET_MODE = INSN_CONFIG_SET_COUNTER_MODE,	/* deprecated */
> +		/* deprecated */

			/* INSN_CONFIG_8254_SET_MODE is deprecated */

[]

> -	static inline unsigned NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
> +	static inline unsigned
> +		NI_CDIO_SCAN_BEGIN_SRC_RTSI(unsigned rtsi_channel)
>  	{
>  		return NI_USUAL_RTSI_SELECT(rtsi_channel);
>  	}

It'd be better to start the functions in column 1

static inline unsigned int NI_CDIO_SCAN_BEGIN_RTSI(unsigned int rtsi_channel)
{
	return NI_USUAL_RTSI_SELECT(rtsi_channel);
}

