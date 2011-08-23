Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1HWTB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:01:59 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58137 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755821Ab1HWTBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:01:49 -0400
X-Sasl-enc: 1t7ruarEA/wYQEnxUpF+tRwBHiT4Gk3mgFVfAN3IxsX0 1314126108
Date: Tue, 23 Aug 2011 11:56:10 -0700
From: Greg KH <greg@kroah.com>
To: markpearson_de@yahoo.de
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: Coding style issues
Message-ID: <20110823185610.GA11467@kroah.com>
References: <1310325398-30449-1-git-send-email-markpearson_de@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310325398-30449-1-git-send-email-markpearson_de@yahoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 09:16:37PM +0200, markpearson_de@yahoo.de wrote:
> From: Mark Pearson <markpearson_de@yahoo.de>
> 
> comedi.h : static inline decleration placed on the same line as the end
>            bracket from the previous static inline decleration.
>            Bracket coding issue also cleaned-up.
> 
> Signed-off-by: Mark Pearson <markpearson_de@yahoo.de>
> ---
>  drivers/staging/comedi/comedi.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
> index 6c900e2..ed6854c 100644
> --- a/drivers/staging/comedi/comedi.h
> +++ b/drivers/staging/comedi/comedi.h
> @@ -514,7 +514,9 @@
>  			return 0x1 + pfi_channel;
>  		else
>  			return 0xb + pfi_channel;
> -	} static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel) {
> +	}
> +	static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel)
> +	{

This patch does not apply anymore to 3.1-rc3, care to resend?

thanks,

greg k-h
