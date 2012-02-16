Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2BPAI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:08:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48948 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756401Ab2BPAIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:08:54 -0500
X-Sasl-enc: dex+e2gfpCWVuxlaxZG0Cgx+8p8FS5MWRDnyJA9KFLUn 1329350926
Date: Wed, 15 Feb 2012 16:07:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rusk, Mark" <mark.rusk@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: misc: hpilo patch for increasing max channels
Message-ID: <20120216000741.GA21792@kroah.com>
References: <20111005155603.10877.25014.sendpatchset@tmingo.usa.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005155603.10877.25014.sendpatchset@tmingo.usa.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 04:57:56PM +0100, Rusk, Mark wrote:
> This patch is to allow for hpilo to support more channels (from 8 to 24) and this is configurable.
> The module parameter, max_ccb, is also readable from /sys/module/hpilo/parameters/max_ccb.
> 
> Signed-off-by: Mark Rusk <mark.rusk@hp.com>
> 
> --- drivers/misc.old/hpilo.c    2011-10-04 17:37:59.000000000 -0500
> +++ drivers/misc/hpilo.c        2011-10-04 17:15:02.000000000 -0500

Please send patches that can be applied with 'patch -p1', as that is
what our tools assume.  Documentation/SubmittingPatches goes into this
quite well.


> @@ -878,11 +883,14 @@
>         class_destroy(ilo_class);
>  }
> 
> -MODULE_VERSION("1.3");
> +MODULE_VERSION("1.2");

Why did you just decrement the module version?

Care to resend this in a format that I can apply it in, after verifying
that you really want to go down in the module version number?

thanks,

greg k-h
