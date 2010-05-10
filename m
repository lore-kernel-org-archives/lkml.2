Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0EJPeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:34:09 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:38072 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab0EJPeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aCHUI4M/B3CQsCsFoZvs0woQCNhiOP5pp37XSMR0CK9pBWNnms7msi7Fo9e+VY5lzx
         JHjtHPtPGM+wDiaIm2uEZXhHCsG68FgsOmrEQHjJ1zNJRu9fPDJYHihecJRbmCplXCoe
         t53gr+haOQ+RXY3w377Lt22H3YL2YasDTnDIc=
Date: Mon, 10 May 2010 08:31:13 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: Mark <reodge@gmail.com>
Cc: gregkh@suse.de, shawn.bohrer@gmail.com, fmhess@users.sourceforge.net,
       andrea.gelmini@gelma.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: Fix long line lengths in comedi_fops.c
Message-ID: <20100510153111.GA28889@fujitsu>
References: <1273484217-4073-1-git-send-email-reodge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1273484217-4073-1-git-send-email-reodge@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On Mon, May 10, 2010 at 05:36:57PM +0800, Mark wrote:
> This patch fixes lots of long line lengths in comedi_fops.c found by
> checkpatch.pl
> 
> Signed-off-by: Mark Rankilor <reodge@gmail.com>
> ---
>  drivers/staging/comedi/comedi_fops.c |   38 ++++++++++++++++++++++-----------
>  1 files changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index e7095d7..9bfab73 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -962,7 +962,8 @@ static int do_insn_ioctl(struct comedi_device *dev,
>  	if (ret < 0)
>  		goto error;
>  	if (insn.insn & INSN_MASK_READ) {
> -		if (copy_to_user(insn.data, data, insn.n * sizeof(unsigned int))) {
> +		if (copy_to_user
> +		    (insn.data, data, insn.n * sizeof(unsigned int))) {

I think it'd be better to keep the opening parenthesis on the same line
of the function and maybe the first argument, too.

> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

-- 
Charles Clément

