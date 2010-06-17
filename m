Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab0FQUgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:36:50 -0400
Received: from kroah.org ([198.145.64.141]:57495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590Ab0FQUgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:36:49 -0400
Date: Thu, 17 Jun 2010 13:34:24 -0700
From: Greg KH <greg@kroah.com>
To: John Sheehan <john.d.sheehan@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, roel.kluin@gmail.com, jkosina@suse.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: fix code style errors in s626.c
Message-ID: <20100617203424.GA32523@kroah.com>
References: <1275060688-18454-1-git-send-email-john.d.sheehan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275060688-18454-1-git-send-email-john.d.sheehan@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 04:31:28PM +0100, John Sheehan wrote:
> From: John Sheehan <john.d.sheehan@gmail.com>
> 
> A patch for s626.c to fix errors reported by
> checkpatch.pl tool, namely,
> code indent should use tabs where possible
> "foo * bar" should be "foo *bar"
> trailing statements should be on next line
> 
> Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
> ---
>  drivers/staging/comedi/drivers/s626.c |   67 +++++++++++++++++++--------------
>  1 files changed, 39 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index a3cc933..83e1bb1 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -60,10 +60,10 @@ INSN_CONFIG instructions:
>     insn.insn=INSN_CONFIG;   //configuration instruction
>     insn.n=1;                //number of operation (must be 1)
>     insn.data=&initialvalue; //initial value loaded into encoder
> -                            //during configuration
> +							//during configuration

Why change this?

>     insn.subdev=5;           //encoder subdevice
>     insn.chanspec=CR_PACK(encoder_channel,0,AREF_OTHER); //encoder_channel
> -                                                        //to configure
> +														//to configure

Why is this line indented so much now?

Care to resend this without these changes?

thanks,

greg k-h
