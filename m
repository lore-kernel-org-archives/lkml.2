Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1GHVA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:00:56 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33506 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169Ab1GHVAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:00:55 -0400
X-Sasl-enc: c1pg5eeRnK43NhyUijnND2NgrBVEGF1YBUdDovLVamBA 1310158854
Date: Fri, 8 Jul 2011 13:53:03 -0700
From: Greg KH <greg@kroah.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 6/6] Staging: comedi: fix warning issue in unioxx5.c
Message-ID: <20110708205303.GA11573@kroah.com>
References: <1310027817-2438-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310027817-2438-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 02:06:57PM +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the unioxx5.c file that fixes up a  warning: line over 80 character by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/unioxx5.c |   30 +++++++++++++++++++++---------
>  1 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index 9b311c7..88dafb7 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -207,7 +207,9 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
>  	int channel, type;
>  
>  	channel = CR_CHAN(insn->chanspec);
> -	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
> +	type = usp->usp_module_type[channel / 2];	/* defining module type
> +							 * (analog or digital)
> +							*/

That doesn't line up properly :(

