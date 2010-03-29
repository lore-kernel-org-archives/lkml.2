Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0C2PWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:22:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab0C2PWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:22:03 -0400
Date: Mon, 29 Mar 2010 08:19:04 -0700
From: Greg KH <gregkh@suse.de>
To: supermine290 <supermine290@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Patch to comedi_fops.c
Message-ID: <20100329151904.GB12015@suse.de>
References: <4BB03C13.7090209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB03C13.7090209@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 01:35:15AM -0400, supermine290 wrote:
> >From eb3bff4e8052a4075d82f1687e0338dc81d73256 Mon Sep 17 00:00:00 2001
> From: Jakob Penzien <jakob@bloodmoon.(none)>
> Date: Tue, 23 Mar 2010 12:52:14 -0400
> Subject: [PATCH] Staging: comedi: fix space before tab style issue
> in comedi_fops.c
>  This is a patch to the comedi_fops.c file that fixes up a tab style
> warning
>  found by the checkpathc.pl tool. This patch was done to 2.6.34 kernel.
>  Signed-off-by: Jakob Penzien <supermine290@gmail.com>
> 
> ---
>  drivers/staging/comedi/comedi_fops.c |   38
> +++++++++++++++++-----------------
>  1 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedi_fops.c
> b/drivers/staging/comedi/comedi_fops.c
> index aca9674..5cb5bc7 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -598,19 +598,19 @@ copyback:
>  static int parse_insn(struct comedi_device *dev, struct comedi_insn
> *insn,

The patch is line-wrapped, can you please fix this and resend it?

thanks,

greg k-h
