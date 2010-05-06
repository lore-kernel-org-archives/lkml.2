Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0EFGWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:22:00 -0400
Received: from kroah.org ([198.145.64.141]:56973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab0EFGV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:21:58 -0400
Date: Wed, 5 May 2010 23:22:32 -0700
From: Greg KH <greg@kroah.com>
To: Zachary Richey <zr.public@gmail.com>
Cc: gregkh@suse.de, fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix coding style issues in
	comedi_fops.c This patch fixes coding style issues reported by
	scripts/checkpatch.pl Signed-off-by: Zachary Richey
	<zr.public@gmail.com>
Message-ID: <20100506062232.GA23101@kroah.com>
References: <1273113587-2809-1-git-send-email-zr.public@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273113587-2809-1-git-send-email-zr.public@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 10:39:47PM -0400, Zachary Richey wrote:
> ---
>  drivers/staging/comedi/comedi_fops.c |   56 +++++++++++++++++-----------------
>  1 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index aca9674..999cbb6 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -598,20 +598,20 @@ copyback:
>  static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
>  		      unsigned int *data, void *file);
>  /*
> - * 	COMEDI_INSNLIST
> - * 	synchronous instructions
> - *
> - * 	arg:
> - * 		pointer to sync cmd structure
> - *
> - * 	reads:
> - * 		sync cmd struct at arg
> - * 		instruction list
> - * 		data (for writes)
> - *
> - * 	writes:
> - * 		data (for reads)
> - */
> +*	COMEDI_INSNLIST
> +*	synchronous instructions
> +*
> +*	arg:
> +*		pointer to sync cmd structure
> +*
> +*	reads:
> +*		sync cmd struct at arg
> +*		instruction list
> +*		data (for writes)
> +*
> +*	writes:
> +*		data (for reads)
> +*/
>  /* arbitrary limits */
>  #define MAX_SAMPLES 256
>  static int do_insnlist_ioctl(struct comedi_device *dev, void *arg, void *file)
> @@ -736,7 +736,7 @@ static int check_insn_config_length(struct comedi_insn *insn,


What warning is this patch resolving?  The original looks correct, a
leading space is fine for something like a comment block like this.

confused,

greg k-h
