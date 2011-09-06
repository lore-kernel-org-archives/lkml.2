Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1IGABG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 20:01:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55275 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419Ab1IGAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 20:00:54 -0400
X-Sasl-enc: Pfy3FfGufiWJIH02/WMvqx61S39VdOlSOQ6JQHXjHgoB 1315353653
Date: Tue, 6 Sep 2011 16:58:46 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: Removed unnecessary "extern" from
 do_become_nonbusy()
Message-ID: <20110906235846.GA10622@kroah.com>
References: <1315150589-3434-1-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315150589-3434-1-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 05:36:29PM +0200, Johannes Thumshirn wrote:
> Removed unnecessary "extern" label from do_become_nonbusy() function to make
> checkpatch.pl happy
> 
> Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
> ---
>  drivers/staging/comedi/comedi_fops.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index e90e3cc..c46db8f 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -101,8 +101,7 @@ static int do_insn_ioctl(struct comedi_device *dev,
>  static int do_poll_ioctl(struct comedi_device *dev, unsigned int subd,
>  			 void *file);
>  
> -extern void do_become_nonbusy(struct comedi_device *dev,
> -			      struct comedi_subdevice *s);
> +void do_become_nonbusy(struct comedi_device *dev, struct comedi_subdevice *s);

This patch does not apply, what tree did you make it against?

Please try it against the latest linux-next tree and resend it.

thanks,

greg k-h
