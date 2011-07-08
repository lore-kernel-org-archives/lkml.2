Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1GHVBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:01:10 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48782 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab1GHVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:00:58 -0400
X-Sasl-enc: FUeI0Xf2acoRwevBVwjeYd1dBXT8Sd7WQCH1nobufQ7u 1310158857
Date: Fri, 8 Jul 2011 13:57:52 -0700
From: Greg KH <greg@kroah.com>
To: ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 2/2] Staging: comedi: fix wraning:line over 80 character
 issue in rtd520.c
Message-ID: <20110708205752.GC11573@kroah.com>
References: <1310121459-12788-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310121459-12788-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 04:07:39PM +0530, ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the rtd520.c file that fixes up a line over 80 charcter warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/rtd520.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
> index 7f09ed7..44dbf43 100644
> --- a/drivers/staging/comedi/drivers/rtd520.c
> +++ b/drivers/staging/comedi/drivers/rtd520.c
> @@ -1403,7 +1403,8 @@ static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
>  
>  		d = d >> 3;	/* low 3 bits are marker lines */
>  		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan))
> -			sample = d + 2048;	/* convert to comedi unsigned data */
> +			/* convert to comedi unsigned data */
> +			sample = d + 2048;

While this will work, it's not a good idea.  Please put braces in here
if you are going to do this.

greg k-h
