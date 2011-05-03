Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1ECVBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:01:41 -0400
Received: from kroah.org ([198.145.64.141]:35297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab1ECVBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:01:40 -0400
Date: Tue, 3 May 2011 14:01:35 -0700
From: Greg KH <greg@kroah.com>
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, hjanssen@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH resend] staging: hv: make HYPERV_UTILS depend on NLS to
 prevent a build error
Message-ID: <20110503210135.GA12954@kroah.com>
References: <alpine.LNX.2.00.1105031642370.2706@gentoo.foleyremote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1105031642370.2706@gentoo.foleyremote.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 04:53:54PM -0400, pefoley2@verizon.net wrote:
> When HYPERV_UTILS=y and NLS=n the build fails with this error:
> MODPOST 3 modules ERROR: "utf8s_to_utf16s"
> [drivers/staging/hv/hv_utils.ko] undefined!
> 
> This patch fixes this by adding a dependency on NLS to HYPERV_UTILS.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  drivers/staging/hv/Kconfig |    2 +-

Nope, still not working, please fix your email client, it is messing up
the patch.  Read the file, Documentation/email_client.txt for hints on
how to do this.

thanks,

greg k-h
